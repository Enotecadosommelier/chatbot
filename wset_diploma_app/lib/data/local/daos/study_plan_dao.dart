import 'package:sqflite/sqflite.dart';

import '../../../core/constants/wset_modules.dart';
import '../../../domain/entities/study_plan.dart';
import '../app_database.dart';

class StudyPlanDao {
  Future<Database> get _db => AppDatabase.instance.database;

  Future<void> saveSessions(String userId, List<StudySession> sessions) async {
    final db = await _db;
    final batch = db.batch();
    batch.delete('study_plan_sessions',
        where: 'userId = ?', whereArgs: [userId]);
    for (final s in sessions) {
      batch.insert('study_plan_sessions', {
        'userId': userId,
        'date': s.date.toIso8601String(),
        'module': s.module.name,
        'focusTopicId': s.focusTopicId,
        'plannedDurationSeconds': s.plannedDuration.inSeconds,
        'completed': s.completed ? 1 : 0,
      });
    }
    await batch.commit(noResult: true);
  }

  Future<List<StudySession>> getSessions(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'study_plan_sessions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date ASC',
    );
    return rows
        .map(
          (r) => StudySession(
            date: DateTime.parse(r['date']! as String),
            module: WsetModule.values.byName(r['module']! as String),
            focusTopicId: r['focusTopicId']! as String,
            plannedDuration:
                Duration(seconds: r['plannedDurationSeconds']! as int),
            completed: (r['completed']! as int) == 1,
          ),
        )
        .toList();
  }

  Future<void> markCompleted(String userId, DateTime date) async {
    final db = await _db;
    await db.update(
      'study_plan_sessions',
      {'completed': 1},
      where: 'userId = ? AND date = ?',
      whereArgs: [userId, date.toIso8601String()],
    );
  }
}
