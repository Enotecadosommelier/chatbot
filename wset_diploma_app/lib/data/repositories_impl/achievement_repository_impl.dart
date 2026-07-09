import '../../domain/entities/achievement.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../local/daos/achievement_dao.dart';
import '../seed/seed_achievements.dart';

class AchievementRepositoryImpl implements AchievementRepository {
  final AchievementDao dao;

  AchievementRepositoryImpl({required this.dao});

  @override
  Future<List<Achievement>> getAllDefinitions() async => kSeedAchievements;

  @override
  Future<List<UnlockedAchievement>> getUnlockedFor(String userId) =>
      dao.getUnlockedFor(userId);

  @override
  Future<void> unlock(String userId, String achievementId) =>
      dao.unlock(userId, achievementId);
}
