import '../entities/leaderboard_entry.dart';

abstract class LeaderboardRepository {
  /// Global top-N ranking. Requires connectivity; callers should fall back
  /// to a "you're offline" state rather than showing stale ranks as current.
  Future<List<LeaderboardEntry>> getGlobalTop({int limit = 100});
  Future<LeaderboardEntry?> getUserRank(String userId);
  Future<void> pushLocalScore(String userId, String displayName, int totalXp);
}
