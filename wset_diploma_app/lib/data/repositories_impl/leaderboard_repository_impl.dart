import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../remote/firebase_leaderboard_datasource.dart';

class LeaderboardRepositoryImpl implements LeaderboardRepository {
  final FirebaseLeaderboardDataSource? remote;

  LeaderboardRepositoryImpl({this.remote});

  @override
  Future<List<LeaderboardEntry>> getGlobalTop({int limit = 100}) async {
    if (remote == null) return const [];
    return remote!.getGlobalTop(limit: limit);
  }

  @override
  Future<LeaderboardEntry?> getUserRank(String userId) async {
    if (remote == null) return null;
    return remote!.getUserRank(userId);
  }

  @override
  Future<void> pushLocalScore(
      String userId, String displayName, int totalXp) async {
    if (remote == null) return;
    await remote!.pushScore(userId, displayName, totalXp);
  }
}
