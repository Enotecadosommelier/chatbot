import 'package:flutter_test/flutter_test.dart';
import 'package:wset_diploma_app/core/adaptive/adaptive_selector.dart';

void main() {
  group('AdaptiveSelector', () {
    final selector = AdaptiveSelector();
    final now = DateTime(2026, 7, 9);

    test('prioritises overdue SRS cards over not-yet-due cards', () {
      final pool = [
        CandidateQuestion(
          id: 'overdue',
          topicId: 'd1.still-wine',
          difficulty: 2,
          srsDueAt: now.subtract(const Duration(days: 5)),
        ),
        CandidateQuestion(
          id: 'not-due',
          topicId: 'd1.still-wine',
          difficulty: 2,
          srsDueAt: now.add(const Duration(days: 5)),
        ),
      ];

      final result = selector.selectNext(
        pool: pool,
        masteryByTopic: {},
        count: 1,
        now: now,
      );

      expect(result.single.id, 'overdue');
    });

    test('prioritises weak topics over strong ones when both are new/due', () {
      final pool = [
        const CandidateQuestion(
            id: 'weak-topic-q', topicId: 'weak', difficulty: 2),
        const CandidateQuestion(
            id: 'strong-topic-q', topicId: 'strong', difficulty: 2),
      ];
      final mastery = {
        'weak':
            const TopicMastery(topicId: 'weak', accuracy: 0.2, attempts: 10),
        'strong':
            const TopicMastery(topicId: 'strong', accuracy: 0.95, attempts: 10),
      };

      final result = selector.selectNext(
        pool: pool,
        masteryByTopic: mastery,
        count: 1,
        now: now,
      );

      expect(result.single.id, 'weak-topic-q');
    });

    test('matches question difficulty to topic mastery level', () {
      final pool = [
        const CandidateQuestion(id: 'easy', topicId: 'x', difficulty: 1),
        const CandidateQuestion(id: 'hard', topicId: 'x', difficulty: 5),
      ];
      // Low mastery -> target difficulty should be low -> "easy" wins.
      final lowMastery = {
        'x': const TopicMastery(topicId: 'x', accuracy: 0.1, attempts: 10),
      };
      final lowResult = selector.selectNext(
        pool: pool,
        masteryByTopic: lowMastery,
        count: 1,
        now: now,
      );
      expect(lowResult.single.id, 'easy');

      // High mastery -> target difficulty should be high -> "hard" wins.
      final highMastery = {
        'x': const TopicMastery(topicId: 'x', accuracy: 0.98, attempts: 10),
      };
      final highResult = selector.selectNext(
        pool: pool,
        masteryByTopic: highMastery,
        count: 1,
        now: now,
      );
      expect(highResult.single.id, 'hard');
    });

    test('returns at most `count` questions, ranked', () {
      final pool = List.generate(
        10,
        (i) => CandidateQuestion(id: 'q$i', topicId: 'x', difficulty: 2),
      );
      final result = selector.selectNext(
        pool: pool,
        masteryByTopic: {},
        count: 4,
        now: now,
      );
      expect(result.length, 4);
    });
  });
}
