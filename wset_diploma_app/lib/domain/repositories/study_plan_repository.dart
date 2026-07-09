import '../entities/study_plan.dart';

abstract class StudyPlanRepository {
  Future<StudyPlan?> getActivePlan(String userId);
  Future<void> savePlan(String userId, StudyPlan plan);
  Future<void> markSessionCompleted(String userId, DateTime sessionDate);
}
