import 'dart:math';

import 'package:uuid/uuid.dart';

import '../../core/constants/wset_modules.dart';
import '../entities/quiz_session.dart';
import '../repositories/question_repository.dart';

/// Assembles a full-length mock exam that mirrors the real WSET paper shape
/// for the chosen module (e.g. D1's 50 multiple-choice questions), rather
/// than a generic random sample.
class GenerateMockExamUseCase {
  final QuestionRepository questionRepository;
  final Uuid uuid;
  final Random random;

  GenerateMockExamUseCase({
    required this.questionRepository,
    Uuid? uuid,
    Random? random,
  })  : uuid = uuid ?? const Uuid(),
        random = random ?? Random();

  static const Map<WsetModule, int> _examQuestionCounts = {
    WsetModule.d1: 50,
    WsetModule.d2: 30,
    WsetModule.d3: 40,
    WsetModule.d4: 25,
    WsetModule.d5: 25,
    WsetModule.d6: 0,
  };

  Future<QuizSession> call(WsetModule module) async {
    final targetCount = _examQuestionCounts[module] ?? 30;
    final available = await questionRepository.getByModule(module);
    final shuffled = [...available]..shuffle(random);
    final questions = shuffled.take(targetCount).toList();

    return QuizSession(
      id: uuid.v4(),
      mode: QuizSessionMode.mockExam,
      questions: questions,
      answers: const [],
      startedAt: DateTime.now(),
    );
  }
}
