import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/entities/leaderboard_entry.dart';
import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/usecases/get_performance_statistics_usecase.dart';
import '../../domain/usecases/search_content_usecase.dart';
import 'providers.dart';

/// Simpler, read-mostly screens use plain FutureProviders/family providers
/// rather than a dedicated StateNotifier — there's no complex in-screen
/// interaction loop to manage beyond "load it, maybe refresh it".

final performanceReportProvider =
    FutureProvider.autoDispose<PerformanceReport>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  return ref.watch(getPerformanceStatisticsUseCaseProvider).call(userId);
});

final activeStudyPlanProvider =
    FutureProvider.autoDispose<StudyPlan?>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  return ref.watch(studyPlanRepositoryProvider).getActivePlan(userId);
});

final globalLeaderboardProvider =
    FutureProvider.autoDispose<List<LeaderboardEntry>>((ref) {
  return ref.watch(leaderboardRepositoryProvider).getGlobalTop();
});

final userLeaderboardRankProvider =
    FutureProvider.autoDispose<LeaderboardEntry?>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  return ref.watch(leaderboardRepositoryProvider).getUserRank(userId);
});

final achievementDefinitionsProvider =
    FutureProvider.autoDispose<List<Achievement>>((ref) {
  return ref.watch(achievementRepositoryProvider).getAllDefinitions();
});

final unlockedAchievementsProvider =
    FutureProvider.autoDispose<List<UnlockedAchievement>>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  return ref.watch(achievementRepositoryProvider).getUnlockedFor(userId);
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose<SearchResults>((ref) {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(searchContentUseCaseProvider).call(query);
});

final favoritesProvider =
    FutureProvider.autoDispose<List<FavoriteItem>>((ref) async {
  final userId = await ref.watch(currentUserIdProvider.future);
  return ref.watch(favoritesRepositoryProvider).getAll(userId);
});

final grapeProfilesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(contentRepositoryProvider).getAllGrapeProfiles();
});

final regionProfilesProvider = FutureProvider.autoDispose((ref) {
  return ref.watch(contentRepositoryProvider).getAllRegionProfiles();
});

final selectedModuleFilterProvider =
    StateProvider.autoDispose<WsetModule?>((ref) => null);
