import 'package:flutter_test/flutter_test.dart';
import 'package:wset_diploma_app/core/constants/wset_modules.dart';
import 'package:wset_diploma_app/domain/entities/question.dart';

Question _sampleQuestion({
  List<int> correct = const [1],
  QuestionType type = QuestionType.singleChoice,
}) {
  return Question(
    id: 'q1',
    module: WsetModule.d1,
    topicIds: const ['d1.fermentation'],
    type: type,
    difficulty: 2,
    prompt: 'Which yeast genus drives alcoholic fermentation?',
    options: const ['Brettanomyces', 'Saccharomyces', 'Oenococcus'],
    correctOptionIndexes: correct,
    explanation: 'Saccharomyces is responsible for alcoholic fermentation.',
  );
}

void main() {
  group('Question.isCorrect', () {
    test('single choice: exact match is correct', () {
      final q = _sampleQuestion(correct: [1]);
      expect(q.isCorrect([1]), isTrue);
    });

    test('single choice: wrong option is incorrect', () {
      final q = _sampleQuestion(correct: [1]);
      expect(q.isCorrect([0]), isFalse);
    });

    test('multiple choice: partial selection is incorrect', () {
      final q =
          _sampleQuestion(correct: [0, 1], type: QuestionType.multipleChoice);
      expect(q.isCorrect([0]), isFalse);
    });

    test('multiple choice: full correct set regardless of order is correct',
        () {
      final q =
          _sampleQuestion(correct: [0, 1], type: QuestionType.multipleChoice);
      expect(q.isCorrect([1, 0]), isTrue);
    });

    test('multiple choice: extra incorrect selection is incorrect', () {
      final q =
          _sampleQuestion(correct: [0, 1], type: QuestionType.multipleChoice);
      expect(q.isCorrect([0, 1, 2]), isFalse);
    });
  });

  group('Question map round-trip', () {
    test('toMap/fromMap preserves all fields', () {
      const original = Question(
        id: 'q2',
        module: WsetModule.d3,
        topicIds: ['d3.bordeaux', 'd3.left-bank'],
        type: QuestionType.multipleChoice,
        difficulty: 4,
        prompt: 'Sample prompt',
        options: ['A', 'B', 'C'],
        correctOptionIndexes: [0, 2],
        modelShortAnswer: '',
        explanation: 'Sample explanation',
        imageAssetPaths: ['assets/images/maps/bordeaux.png'],
        references: ['WSET D3 Study Guide'],
        tags: ['bordeaux', 'left bank'],
      );

      final roundTripped = Question.fromMap(original.toMap());

      expect(roundTripped.id, original.id);
      expect(roundTripped.module, original.module);
      expect(roundTripped.topicIds, original.topicIds);
      expect(roundTripped.type, original.type);
      expect(roundTripped.difficulty, original.difficulty);
      expect(roundTripped.options, original.options);
      expect(roundTripped.correctOptionIndexes, original.correctOptionIndexes);
      expect(roundTripped.imageAssetPaths, original.imageAssetPaths);
      expect(roundTripped.references, original.references);
      expect(roundTripped.tags, original.tags);
    });
  });
}
