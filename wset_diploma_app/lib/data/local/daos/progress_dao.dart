import 'package:sqflite/sqflite.dart';

import '../../../core/constants/wset_modules.dart';
import '../../../core/spaced_repetition/sm2_scheduler.dart';
import '../../../domain/entities/srs_state.dart';
import '../../../domain/entities/user_progress.dart';
import '../app_database.dart';

class ProgressDao {
  Future<Database> get _db => AppDatabase.instance.database;

  // --- SRS state -----------------------------------------------------

  Map<String, Object?> _srsToRow(SrsState s) => {
        'cardId': s.cardId,
        'easinessFactor': s.schedule.easinessFactor,
        'repetitions': s.schedule.repetitions,
        'intervalDays': s.schedule.intervalDays,
        'dueAt': s.schedule.dueAt.toIso8601String(),
        'totalReviews': s.totalReviews,
        'correctReviews': s.correctReviews,
      };

  SrsState _srsFromRow(Map<String, Object?> row) => SrsState(
        cardId: row['cardId']! as String,
        schedule: SrsCardState(
          easinessFactor: (row['easinessFactor']! as num).toDouble(),
          repetitions: row['repetitions']! as int,
          intervalDays: row['intervalDays']! as int,
          dueAt: DateTime.parse(row['dueAt']! as String),
        ),
        totalReviews: row['totalReviews']! as int,
        correctReviews: row['correctReviews']! as int,
      );

  Future<SrsState?> getSrsState(String cardId) async {
    final db = await _db;
    final rows =
        await db.query('srs_states', where: 'cardId = ?', whereArgs: [cardId]);
    if (rows.isEmpty) return null;
    return _srsFromRow(rows.first);
  }

  Future<Map<String, SrsState>> getAllSrsStates() async {
    final db = await _db;
    final rows = await db.query('srs_states');
    return {for (final r in rows) r['cardId']! as String: _srsFromRow(r)};
  }

  Future<void> saveSrsState(SrsState state) async {
    final db = await _db;
    await db.insert(
      'srs_states',
      _srsToRow(state),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SrsState>> getDueCards({required DateTime now}) async {
    final db = await _db;
    final rows = await db.query(
      'srs_states',
      where: 'dueAt <= ?',
      whereArgs: [now.toIso8601String()],
      orderBy: 'dueAt ASC',
    );
    return rows.map(_srsFromRow).toList();
  }

  // --- Topic mastery & user progress ----------------------------------

  Future<void> recordAnswer({
    required String userId,
    required String topicId,
    required WsetModule module,
    required bool wasCorrect,
    required int xpEarned,
    required DateTime now,
  }) async {
    final db = await _db;
    await db.transaction((txn) async {
      final existing = await txn.query(
        'topic_mastery',
        where: 'userId = ? AND topicId = ?',
        whereArgs: [userId, topicId],
      );

      final attempts =
          (existing.isEmpty ? 0 : existing.first['attempts']! as int) + 1;
      final correct =
          (existing.isEmpty ? 0 : existing.first['correct']! as int) +
              (wasCorrect ? 1 : 0);

      await txn.insert(
        'topic_mastery',
        {
          'userId': userId,
          'topicId': topicId,
          'module': module.name,
          'attempts': attempts,
          'correct': correct,
          'lastAttemptAt': now.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      final progressRows = await txn
          .query('user_progress', where: 'userId = ?', whereArgs: [userId]);
      final previousXp =
          progressRows.isEmpty ? 0 : progressRows.first['totalXp']! as int;
      final previousStreak = progressRows.isEmpty
          ? 0
          : progressRows.first['currentStreakDays']! as int;
      final previousLongest = progressRows.isEmpty
          ? 0
          : progressRows.first['longestStreakDays']! as int;
      final lastStudiedRaw = progressRows.isEmpty
          ? null
          : progressRows.first['lastStudiedAt'] as String?;

      final streakInfo = _computeStreak(
        lastStudiedAt:
            lastStudiedRaw != null ? DateTime.parse(lastStudiedRaw) : null,
        now: now,
        previousStreak: previousStreak,
      );

      await txn.insert(
        'user_progress',
        {
          'userId': userId,
          'totalXp': previousXp + xpEarned,
          'currentStreakDays': streakInfo.$1,
          'longestStreakDays':
              streakInfo.$1 > previousLongest ? streakInfo.$1 : previousLongest,
          'lastStudiedAt': now.toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  /// Returns the updated streak length. A new day of activity extends the
  /// streak by one; a gap of more than a day resets it to 1; same-day
  /// activity leaves it unchanged.
  (int,) _computeStreak({
    required DateTime? lastStudiedAt,
    required DateTime now,
    required int previousStreak,
  }) {
    if (lastStudiedAt == null) return (1,);
    final lastDay =
        DateTime(lastStudiedAt.year, lastStudiedAt.month, lastStudiedAt.day);
    final today = DateTime(now.year, now.month, now.day);
    final dayGap = today.difference(lastDay).inDays;
    if (dayGap == 0) return (previousStreak == 0 ? 1 : previousStreak,);
    if (dayGap == 1) return (previousStreak + 1,);
    return (1,);
  }

  Future<UserProgress> getUserProgress(String userId) async {
    final db = await _db;
    final progressRows = await db
        .query('user_progress', where: 'userId = ?', whereArgs: [userId]);
    final masteryRows = await db
        .query('topic_mastery', where: 'userId = ?', whereArgs: [userId]);

    final masteryByTopic = {
      for (final row in masteryRows)
        row['topicId']! as String: TopicMasterySnapshot(
          topicId: row['topicId']! as String,
          module: WsetModule.values.byName(row['module']! as String),
          attempts: row['attempts']! as int,
          correct: row['correct']! as int,
          lastAttemptAt: DateTime.parse(row['lastAttemptAt']! as String),
        ),
    };

    if (progressRows.isEmpty) {
      return UserProgress(
        userId: userId,
        totalXp: 0,
        currentStreakDays: 0,
        longestStreakDays: 0,
        masteryByTopic: masteryByTopic,
      );
    }

    final row = progressRows.first;
    return UserProgress(
      userId: userId,
      totalXp: row['totalXp']! as int,
      currentStreakDays: row['currentStreakDays']! as int,
      longestStreakDays: row['longestStreakDays']! as int,
      lastStudiedAt: row['lastStudiedAt'] != null
          ? DateTime.parse(row['lastStudiedAt']! as String)
          : null,
      masteryByTopic: masteryByTopic,
    );
  }
}
