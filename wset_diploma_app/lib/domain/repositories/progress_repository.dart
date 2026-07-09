import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../entities/srs_state.dart';
import '../entities/user_progress.dart';

abstract class ProgressRepository {
  Future<UserProgress> getUserProgress(String userId);
  Future<void> recordAnswer({
    required String userId,
    required String topicId,
    required bool wasCorrect,
    required int xpEarned,
  });

  Future<SrsState> getSrsState(String cardId);
  Future<Map<String, SrsState>> getAllSrsStates();
  Future<void> saveSrsState(SrsState state);

  /// All cards due for review at or before [now], ordered soonest-due first.
  Future<List<SrsState>> getDueCards({required DateTime now});

  Future<void> gradeReview({
    required String cardId,
    required RecallGrade grade,
    required bool wasCorrect,
  });
}
