import '../../core/constants/wset_modules.dart';
import '../entities/study_plan.dart';
import '../repositories/progress_repository.dart';
import '../repositories/study_plan_repository.dart';

/// Builds a day-by-day countdown plan to [examDate], allocating more
/// sessions to the learner's weakest topics within [targetModule].
class GenerateStudyPlanUseCase {
  final ProgressRepository progressRepository;
  final StudyPlanRepository studyPlanRepository;

  GenerateStudyPlanUseCase({
    required this.progressRepository,
    required this.studyPlanRepository,
  });

  Future<StudyPlan> call({
    required String userId,
    required WsetModule targetModule,
    required DateTime examDate,
    Duration dailySessionLength = const Duration(minutes: 45),
  }) async {
    final progress = await progressRepository.getUserProgress(userId);
    final moduleTopics = progress.masteryByTopic.values
        .where((s) => s.module == targetModule)
        .toList()
      ..sort((a, b) => a.accuracy.compareTo(b.accuracy));

    final topicIds = moduleTopics.isEmpty
        ? ['${targetModule.name}.foundations']
        : moduleTopics.map((s) => s.topicId).toList();

    final today = DateTime.now();
    final days = examDate.difference(today).inDays.clamp(1, 365);

    final sessions = List.generate(days, (i) {
      final date = DateTime(today.year, today.month, today.day + i + 1);
      final topicId = topicIds[i % topicIds.length];
      return StudySession(
        date: date,
        module: targetModule,
        focusTopicId: topicId,
        plannedDuration: dailySessionLength,
      );
    });

    final plan = StudyPlan(
      examDate: examDate,
      targetModule: targetModule,
      sessions: sessions,
    );

    await studyPlanRepository.savePlan(userId, plan);
    return plan;
  }
}
