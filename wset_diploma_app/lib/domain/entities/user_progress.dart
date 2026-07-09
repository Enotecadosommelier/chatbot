import '../../core/constants/wset_modules.dart';

/// Rolling performance snapshot for one topic, used by the adaptive engine,
/// the statistics dashboard, and the study planner.
class TopicMasterySnapshot {
  final String topicId;
  final WsetModule module;
  final int attempts;
  final int correct;
  final DateTime lastAttemptAt;

  const TopicMasterySnapshot({
    required this.topicId,
    required this.module,
    required this.attempts,
    required this.correct,
    required this.lastAttemptAt,
  });

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// Aggregate profile for the signed-in learner: XP/level for gamification,
/// streaks, and per-topic mastery used to drive adaptive selection.
class UserProgress {
  final String userId;
  final int totalXp;
  final int currentStreakDays;
  final int longestStreakDays;
  final DateTime? lastStudiedAt;
  final Map<String, TopicMasterySnapshot> masteryByTopic;

  const UserProgress({
    required this.userId,
    required this.totalXp,
    required this.currentStreakDays,
    required this.longestStreakDays,
    required this.masteryByTopic,
    this.lastStudiedAt,
  });

  factory UserProgress.empty(String userId) => UserProgress(
        userId: userId,
        totalXp: 0,
        currentStreakDays: 0,
        longestStreakDays: 0,
        masteryByTopic: const {},
      );

  int get level => 1 + (totalXp / 500).floor();
  int get xpIntoCurrentLevel => totalXp % 500;
  int get xpToNextLevel => 500 - xpIntoCurrentLevel;
}
