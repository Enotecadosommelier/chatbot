import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../domain/entities/quiz_session.dart';
import 'providers.dart';

class MockExamController extends StateNotifier<AsyncValue<QuizSession?>> {
  final Ref ref;

  MockExamController(this.ref) : super(const AsyncValue.data(null));

  Future<void> generate(WsetModule module) async {
    state = const AsyncValue.loading();
    try {
      final session =
          await ref.read(generateMockExamUseCaseProvider).call(module);
      state = AsyncValue.data(session);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> submitAnswer({
    required String userId,
    required List<int> selectedOptionIndexes,
    required Duration timeTaken,
  }) async {
    final session = state.value;
    if (session == null || session.currentQuestion == null) return;

    final result = await ref.read(submitQuizAnswerUseCaseProvider).call(
          userId: userId,
          question: session.currentQuestion!,
          selectedOptionIndexes: selectedOptionIndexes,
          timeTaken: timeTaken,
        );

    state = AsyncValue.data(
      QuizSession(
        id: session.id,
        mode: session.mode,
        questions: session.questions,
        answers: [...session.answers, result.answer],
        startedAt: session.startedAt,
        finishedAt: session.answers.length + 1 == session.questions.length
            ? DateTime.now()
            : null,
      ),
    );
  }
}

final mockExamControllerProvider = StateNotifierProvider.autoDispose<
    MockExamController, AsyncValue<QuizSession?>>(
  (ref) => MockExamController(ref),
);
