import '../../core/constants/wset_modules.dart';
import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../../domain/entities/srs_state.dart';
import '../../domain/entities/user_progress.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../local/daos/progress_dao.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressDao dao;
  final QuestionRepository questionRepository;
  final Sm2Scheduler scheduler;

  ProgressRepositoryImpl({
    required this.dao,
    required this.questionRepository,
    Sm2Scheduler? scheduler,
  }) : scheduler = scheduler ?? Sm2Scheduler();

  @override
  Future<UserProgress> getUserProgress(String userId) =>
      dao.getUserProgress(userId);

  @override
  Future<void> recordAnswer({
    required String userId,
    required String topicId,
    required bool wasCorrect,
    required int xpEarned,
  }) async {
    final module = _inferModuleFromTopicId(topicId);
    await dao.recordAnswer(
      userId: userId,
      topicId: topicId,
      module: module,
      wasCorrect: wasCorrect,
      xpEarned: xpEarned,
      now: DateTime.now(),
    );
  }

  /// Topic ids are namespaced as `<module>.<slug>` (e.g. `d1.fermentation`)
  /// by convention across the seed data, so the module can be recovered
  /// without a second lookup table.
  WsetModule _inferModuleFromTopicId(String topicId) {
    final prefix = topicId.split('.').first;
    return WsetModule.values.firstWhere(
      (m) => m.name == prefix,
      orElse: () => WsetModule.d1,
    );
  }

  @override
  Future<SrsState> getSrsState(String cardId) async {
    return await dao.getSrsState(cardId) ?? SrsState.initial(cardId);
  }

  @override
  Future<Map<String, SrsState>> getAllSrsStates() => dao.getAllSrsStates();

  @override
  Future<void> saveSrsState(SrsState state) => dao.saveSrsState(state);

  @override
  Future<List<SrsState>> getDueCards({required DateTime now}) =>
      dao.getDueCards(now: now);

  @override
  Future<void> gradeReview({
    required String cardId,
    required RecallGrade grade,
    required bool wasCorrect,
  }) async {
    final current = await getSrsState(cardId);
    final nextSchedule = scheduler.schedule(current.schedule, grade);
    final next = current.withReview(nextSchedule, wasCorrect: wasCorrect);
    await dao.saveSrsState(next);
  }
}
