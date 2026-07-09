import 'package:sqflite/sqflite.dart';

import '../../../domain/entities/achievement.dart';
import '../app_database.dart';

class AchievementDao {
  Future<Database> get _db => AppDatabase.instance.database;

  Future<List<UnlockedAchievement>> getUnlockedFor(String userId) async {
    final db = await _db;
    final rows = await db.query(
      'unlocked_achievements',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return rows
        .map(
          (r) => UnlockedAchievement(
            achievementId: r['achievementId']! as String,
            unlockedAt: DateTime.parse(r['unlockedAt']! as String),
          ),
        )
        .toList();
  }

  Future<void> unlock(String userId, String achievementId,
      {DateTime? now}) async {
    final db = await _db;
    await db.insert(
      'unlocked_achievements',
      {
        'userId': userId,
        'achievementId': achievementId,
        'unlockedAt': (now ?? DateTime.now()).toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }
}
