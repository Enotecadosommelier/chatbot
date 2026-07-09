import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../../domain/entities/flashcard.dart';
import 'providers.dart';

class FlashcardQueueState {
  final List<Flashcard> queue;
  final int currentIndex;
  final bool isFlipped;

  const FlashcardQueueState({
    required this.queue,
    this.currentIndex = 0,
    this.isFlipped = false,
  });

  Flashcard? get current =>
      currentIndex < queue.length ? queue[currentIndex] : null;

  bool get isComplete => currentIndex >= queue.length;

  FlashcardQueueState copyWith({int? currentIndex, bool? isFlipped}) {
    return FlashcardQueueState(
      queue: queue,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
    );
  }
}

class FlashcardController
    extends StateNotifier<AsyncValue<FlashcardQueueState>> {
  final Ref ref;

  FlashcardController(this.ref) : super(const AsyncValue.loading());

  Future<void> loadDueQueue({WsetModule? module}) async {
    state = const AsyncValue.loading();
    try {
      final cards = module != null
          ? await ref.read(flashcardRepositoryProvider).getByModule(module)
          : await Future.wait(
              WsetModule.values.map(
                (m) => ref.read(flashcardRepositoryProvider).getByModule(m),
              ),
            ).then((lists) => lists.expand((l) => l).toList());

      final dueStates = await ref
          .read(progressRepositoryProvider)
          .getDueCards(now: DateTime.now());
      final dueIds = dueStates.map((s) => s.cardId).toSet();

      final due = cards.where((c) => dueIds.contains(c.id)).toList();
      final newCards = cards.where((c) => !dueIds.contains(c.id)).toList();
      final queue = [...due, ...newCards];

      state = AsyncValue.data(FlashcardQueueState(queue: queue));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void flip() {
    final current = state.value;
    if (current == null) return;
    state = AsyncValue.data(current.copyWith(isFlipped: !current.isFlipped));
  }

  Future<void> grade(RecallGrade grade) async {
    final current = state.value;
    if (current == null || current.current == null) return;

    await ref.read(reviewFlashcardUseCaseProvider).call(
          flashcardId: current.current!.id,
          grade: grade,
        );

    state = AsyncValue.data(
      current.copyWith(
        currentIndex: current.currentIndex + 1,
        isFlipped: false,
      ),
    );
  }
}

final flashcardControllerProvider = StateNotifierProvider.autoDispose<
    FlashcardController, AsyncValue<FlashcardQueueState>>(
  (ref) => FlashcardController(ref),
);
