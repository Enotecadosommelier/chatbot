import '../../domain/entities/study_plan.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../local/daos/study_plan_dao.dart';

class StudyPlanRepositoryImpl implements StudyPlanRepository {
  final StudyPlanDao dao;

  StudyPlanRepositoryImpl({required this.dao});

  @override
  Future<StudyPlan?> getActivePlan(String userId) async {
    final sessions = await dao.getSessions(userId);
    if (sessions.isEmpty) return null;
    final examDate = sessions.last.date;
    return StudyPlan(
      examDate: examDate,
      targetModule: sessions.first.module,
      sessions: sessions,
    );
  }

  @override
  Future<void> savePlan(String userId, StudyPlan plan) =>
      dao.saveSessions(userId, plan.sessions);

  @override
  Future<void> markSessionCompleted(String userId, DateTime sessionDate) =>
      dao.markCompleted(userId, sessionDate);
}
