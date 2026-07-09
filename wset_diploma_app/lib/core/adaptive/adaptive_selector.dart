/// Adaptive quiz question selection.
///
/// Mirrors lib/core/adaptive/adaptive_selector.dart in the production app.
/// Pure Dart so it is unit-testable without the Flutter SDK.
library adaptive_selector;

class TopicMastery {
  final String topicId;
  final double accuracy; // 0.0 - 1.0 rolling accuracy on this topic
  final int attempts;

  const TopicMastery({
    required this.topicId,
    required this.accuracy,
    required this.attempts,
  });
}

class CandidateQuestion {
  final String id;
  final String topicId;
  final DateTime? srsDueAt;
  final int difficulty; // 1 (foundation) - 5 (advanced/exam-level)

  const CandidateQuestion({
    required this.id,
    required this.topicId,
    required this.difficulty,
    this.srsDueAt,
  });
}

/// Picks the next [count] questions for a session by blending three
/// signals: spaced-repetition due-ness, topic weakness, and difficulty
/// suited to the learner's current mastery of that topic.
class AdaptiveSelector {
  List<CandidateQuestion> selectNext({
    required List<CandidateQuestion> pool,
    required Map<String, TopicMastery> masteryByTopic,
    required int count,
    DateTime? now,
  }) {
    final reviewTime = now ?? DateTime.now();

    double scoreOf(CandidateQuestion q) {
      double score = 0;

      // 1. Overdue SRS cards get priority proportional to how overdue they are.
      if (q.srsDueAt != null) {
        final overdueDays = reviewTime.difference(q.srsDueAt!).inHours / 24.0;
        if (overdueDays >= 0) {
          score += 100 + overdueDays.clamp(0, 30) * 2;
        } else {
          // Not due yet: heavily deprioritise but don't fully exclude,
          // so a short session can still be filled.
          score -= overdueDays.abs().clamp(0, 30);
        }
      } else {
        // Never studied: moderate priority, so new material is introduced
        // steadily rather than all at once.
        score += 40;
      }

      // 2. Weak topics (low accuracy, enough attempts to be meaningful)
      final mastery = masteryByTopic[q.topicId];
      if (mastery != null && mastery.attempts >= 3) {
        score += (1.0 - mastery.accuracy) * 60;

        // 3. Difficulty should track mastery: don't throw D5 questions at
        // someone still below 50% on the topic, and don't bore an expert
        // with D1 questions.
        final targetDifficulty = 1 + (mastery.accuracy * 4).round();
        final difficultyGap = (q.difficulty - targetDifficulty).abs();
        score -= difficultyGap * 8;
      } else {
        // Unknown mastery: prefer easier/foundation questions first.
        score -= (q.difficulty - 2).clamp(0, 3) * 5;
      }

      return score;
    }

    final ranked = [...pool]..sort((a, b) => scoreOf(b).compareTo(scoreOf(a)));
    return ranked.take(count).toList();
  }
}
