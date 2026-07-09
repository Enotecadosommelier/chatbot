import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../domain/entities/quiz_session.dart';
import 'providers.dart';

class QuizUiState {
  final QuizSession? session;
  final List<int> selectedOptionIndexes;
  final bool answerRevealed;
  final int lastXpEarned;
  final DateTime? questionStartedAt;

  const QuizUiState({
    this.session,
    this.selectedOptionIndexes = const [],
    this.answerRevealed = false,
    this.lastXpEarned = 0,
    this.questionStartedAt,
  });

  QuizUiState copyWith({
    QuizSession? session,
    List<int>? selectedOptionIndexes,
    bool? answerRevealed,
    int? lastXpEarned,
    DateTime? questionStartedAt,
  }) {
    return QuizUiState(
      session: session ?? this.session,
      selectedOptionIndexes:
          selectedOptionIndexes ?? this.selectedOptionIndexes,
      answerRevealed: answerRevealed ?? this.answerRevealed,
      lastXpEarned: lastXpEarned ?? this.lastXpEarned,
      questionStartedAt: questionStartedAt ?? this.questionStartedAt,
    );
  }
}

class QuizController extends StateNotifier<AsyncValue<QuizUiState>> {
  final Ref ref;

  QuizController(this.ref) : super(const AsyncValue.loading());

  Future<void> startAdaptiveSession({WsetModule? module}) async {
    state = const AsyncValue.loading();
    try {
      final userId = await ref.read(currentUserIdProvider.future);
      final session =
          await ref.read(getAdaptiveQuizSessionUseCaseProvider).call(
                userId: userId,
                restrictToModule: module,
              );
      state = AsyncValue.data(
          QuizUiState(session: session, questionStartedAt: DateTime.now()));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void loadSession(QuizSession session) {
    state = AsyncValue.data(
        QuizUiState(session: session, questionStartedAt: DateTime.now()));
  }

  void toggleOption(int index, {required bool singleChoice}) {
    final current = state.value;
    if (current == null || current.answerRevealed) return;

    final selected = [...current.selectedOptionIndexes];
    if (singleChoice) {
      state = AsyncValue.data(current.copyWith(selectedOptionIndexes: [index]));
      return;
    }

    if (selected.contains(index)) {
      selected.remove(index);
    } else {
      selected.add(index);
    }
    state = AsyncValue.data(current.copyWith(selectedOptionIndexes: selected));
  }

  Future<void> submitAnswer() async {
    final current = state.value;
    if (current == null || current.session == null) return;
    final question = current.session!.currentQuestion;
    if (question == null) return;

    final userId = await ref.read(currentUserIdProvider.future);
    final timeTaken =
        DateTime.now().difference(current.questionStartedAt ?? DateTime.now());

    final result = await ref.read(submitQuizAnswerUseCaseProvider).call(
          userId: userId,
          question: question,
          selectedOptionIndexes: current.selectedOptionIndexes,
          timeTaken: timeTaken,
        );

    final updatedSession = QuizSession(
      id: current.session!.id,
      mode: current.session!.mode,
      questions: current.session!.questions,
      answers: [...current.session!.answers, result.answer],
      startedAt: current.session!.startedAt,
    );

    state = AsyncValue.data(
      current.copyWith(
        session: updatedSession,
        answerRevealed: true,
        lastXpEarned: result.xpEarned,
      ),
    );
  }

  void nextQuestion() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(
      current.copyWith(
        selectedOptionIndexes: const [],
        answerRevealed: false,
        questionStartedAt: DateTime.now(),
      ),
    );
  }
}

final quizControllerProvider =
    StateNotifierProvider.autoDispose<QuizController, AsyncValue<QuizUiState>>(
  (ref) => QuizController(ref),
);
