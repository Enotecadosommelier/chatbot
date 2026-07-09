import '../entities/achievement.dart';

abstract class AchievementRepository {
  Future<List<Achievement>> getAllDefinitions();
  Future<List<UnlockedAchievement>> getUnlockedFor(String userId);
  Future<void> unlock(String userId, String achievementId);
}
