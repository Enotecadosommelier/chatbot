import '../../core/constants/wset_modules.dart';

enum QuestionType { singleChoice, multipleChoice, shortAnswer, essayPrompt }

/// A single answerable item in the question bank.
///
/// Every question is tagged with a [module] (D1-D6) and one or more
/// [topicIds] (e.g. `d1.fermentation`, `d3.loire.chenin-blanc`) so the
/// adaptive engine, search, and statistics can all reason about the same
/// taxonomy.
class Question {
  final String id;
  final WsetModule module;
  final List<String> topicIds;
  final QuestionType type;
  final int difficulty; // 1 (foundation) - 5 (exam-level)
  final String prompt;
  final List<String> options; // empty for shortAnswer/essayPrompt
  final List<int> correctOptionIndexes; // indexes into [options]
  final String modelShortAnswer; // used when type == shortAnswer
  final String explanation;
  final List<String> imageAssetPaths;
  final List<String> references; // e.g. WSET D1 Study Guide, Ch.3
  final List<String> tags;

  const Question({
    required this.id,
    required this.module,
    required this.topicIds,
    required this.type,
    required this.difficulty,
    required this.prompt,
    required this.explanation,
    this.options = const [],
    this.correctOptionIndexes = const [],
    this.modelShortAnswer = '',
    this.imageAssetPaths = const [],
    this.references = const [],
    this.tags = const [],
  }) : assert(
          difficulty >= 1 && difficulty <= 5,
          'difficulty must be between 1 and 5',
        );

  bool isCorrect(List<int> selectedOptionIndexes) {
    final selected = {...selectedOptionIndexes};
    final correct = {...correctOptionIndexes};
    return selected.length == correct.length && selected.containsAll(correct);
  }

  Map<String, Object?> toMap() => {
        'id': id,
        'module': module.name,
        'topicIds': topicIds.join('|'),
        'type': type.name,
        'difficulty': difficulty,
        'prompt': prompt,
        'options': options.join(''),
        'correctOptionIndexes':
            correctOptionIndexes.map((e) => e.toString()).join(','),
        'modelShortAnswer': modelShortAnswer,
        'explanation': explanation,
        'imageAssetPaths': imageAssetPaths.join('|'),
        'references': references.join('|'),
        'tags': tags.join('|'),
      };

  factory Question.fromMap(Map<String, Object?> map) => Question(
        id: map['id']! as String,
        module: WsetModule.values.byName(map['module']! as String),
        topicIds: (map['topicIds']! as String)
            .split('|')
            .where((e) => e.isNotEmpty)
            .toList(),
        type: QuestionType.values.byName(map['type']! as String),
        difficulty: map['difficulty']! as int,
        prompt: map['prompt']! as String,
        options: (map['options']! as String)
            .split('')
            .where((e) => e.isNotEmpty)
            .toList(),
        correctOptionIndexes: (map['correctOptionIndexes']! as String)
            .split(',')
            .where((e) => e.isNotEmpty)
            .map(int.parse)
            .toList(),
        modelShortAnswer: map['modelShortAnswer']! as String,
        explanation: map['explanation']! as String,
        imageAssetPaths: (map['imageAssetPaths']! as String)
            .split('|')
            .where((e) => e.isNotEmpty)
            .toList(),
        references: (map['references']! as String)
            .split('|')
            .where((e) => e.isNotEmpty)
            .toList(),
        tags: (map['tags']! as String)
            .split('|')
            .where((e) => e.isNotEmpty)
            .toList(),
      );
}
