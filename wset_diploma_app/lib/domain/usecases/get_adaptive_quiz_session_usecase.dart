import 'package:uuid/uuid.dart';

import '../../core/adaptive/adaptive_selector.dart';
import '../../core/constants/wset_modules.dart';
import '../entities/question.dart';
import '../entities/quiz_session.dart';
import '../repositories/progress_repository.dart';
import '../repositories/question_repository.dart';

/// Builds an adaptive-practice quiz session by blending spaced-repetition
/// due-ness with topic mastery, using [AdaptiveSelector].
class GetAdaptiveQuizSessionUseCase {
  final QuestionRepository questionRepository;
  final ProgressRepository progressRepository;
  final AdaptiveSelector selector;
  final Uuid uuid;

  GetAdaptiveQuizSessionUseCase({
    required this.questionRepository,
    required this.progressRepository,
    AdaptiveSelector? selector,
    Uuid? uuid,
  })  : selector = selector ?? AdaptiveSelector(),
        uuid = uuid ?? const Uuid();

  Future<QuizSession> call({
    required String userId,
    WsetModule? restrictToModule,
    int questionCount = 15,
  }) async {
    final pool = restrictToModule != null
        ? await questionRepository.getByModule(restrictToModule)
        : await Future.wait(
                WsetModule.values.map(questionRepository.getByModule))
            .then((lists) => lists.expand((l) => l).toList());

    final srsStates = await progressRepository.getAllSrsStates();
    final userProgress = await progressRepository.getUserProgress(userId);

    final candidates = pool
        .map(
          (q) => CandidateQuestion(
            id: q.id,
            topicId: q.topicIds.isNotEmpty ? q.topicIds.first : q.module.name,
            difficulty: q.difficulty,
            srsDueAt: srsStates[q.id]?.schedule.dueAt,
          ),
        )
        .toList();

    final masteryByTopic = <String, TopicMastery>{
      for (final entry in userProgress.masteryByTopic.entries)
        entry.key: TopicMastery(
          topicId: entry.key,
          accuracy: entry.value.accuracy,
          attempts: entry.value.attempts,
        ),
    };

    final selected = selector.selectNext(
      pool: candidates,
      masteryByTopic: masteryByTopic,
      count: questionCount,
    );

    final selectedIds = selected.map((c) => c.id).toList();
    final questions = await questionRepository.getByIds(selectedIds);
    // Preserve the ranked order returned by the selector.
    final byId = {for (final q in questions) q.id: q};
    final orderedQuestions =
        selectedIds.map((id) => byId[id]).whereType<Question>().toList();

    return QuizSession(
      id: uuid.v4(),
      mode: QuizSessionMode.adaptivePractice,
      questions: orderedQuestions,
      answers: const [],
      startedAt: DateTime.now(),
    );
  }
}
