import '../../core/constants/wset_modules.dart';
import '../entities/user_progress.dart';
import '../repositories/progress_repository.dart';

class ModuleStatistics {
  final WsetModule module;
  final int attempts;
  final int correct;
  final List<TopicMasterySnapshot> weakestTopics;

  const ModuleStatistics({
    required this.module,
    required this.attempts,
    required this.correct,
    required this.weakestTopics,
  });

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

class PerformanceReport {
  final UserProgress userProgress;
  final List<ModuleStatistics> byModule;

  const PerformanceReport({required this.userProgress, required this.byModule});
}

/// Aggregates raw per-topic mastery into per-module rollups and surfaces the
/// weakest topics so the Statistics screen and Study Planner can point the
/// learner at exactly what to review next.
class GetPerformanceStatisticsUseCase {
  final ProgressRepository progressRepository;

  GetPerformanceStatisticsUseCase({required this.progressRepository});

  Future<PerformanceReport> call(String userId) async {
    final progress = await progressRepository.getUserProgress(userId);

    final byModule = <WsetModule, List<TopicMasterySnapshot>>{};
    for (final snapshot in progress.masteryByTopic.values) {
      byModule.putIfAbsent(snapshot.module, () => []).add(snapshot);
    }

    final moduleStats = WsetModule.values.map((module) {
      final snapshots = byModule[module] ?? const <TopicMasterySnapshot>[];
      final attempts = snapshots.fold<int>(0, (sum, s) => sum + s.attempts);
      final correct = snapshots.fold<int>(0, (sum, s) => sum + s.correct);
      final weakest = [...snapshots]
        ..sort((a, b) => a.accuracy.compareTo(b.accuracy));
      return ModuleStatistics(
        module: module,
        attempts: attempts,
        correct: correct,
        weakestTopics: weakest.take(5).toList(),
      );
    }).toList();

    return PerformanceReport(userProgress: progress, byModule: moduleStats);
  }
}
