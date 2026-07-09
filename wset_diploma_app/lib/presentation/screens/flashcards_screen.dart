import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../../core/theme/app_colors.dart';
import '../state/flashcard_controller.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  const FlashcardsScreen({super.key});

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => ref.read(flashcardControllerProvider.notifier).loadDueQueue());
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(flashcardControllerProvider);
    final controller = ref.read(flashcardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load flashcards: $e')),
        data: (queueState) {
          if (queueState.queue.isEmpty) {
            return const Center(child: Text('No flashcards available yet.'));
          }
          if (queueState.isComplete) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.style, size: 64),
                    const SizedBox(height: 16),
                    Text(
                      'Deck complete for now — nice work!',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back to home'),
                    ),
                  ],
                ),
              ),
            );
          }

          final card = queueState.current!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${queueState.currentIndex + 1} / ${queueState.queue.length}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: controller.flip,
                    child: Card(
                      color: queueState.isFlipped
                          ? AppColors.gold.withValues(alpha: 0.15)
                          : Theme.of(context).cardColor,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            queueState.isFlipped ? card.back : card.front,
                            style: Theme.of(context).textTheme.headlineSmall,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!queueState.isFlipped)
                  FilledButton(
                      onPressed: controller.flip,
                      child: const Text('Reveal answer'))
                else
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.grade(RecallGrade.again),
                          child: const Text('Again'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.grade(RecallGrade.hard),
                          child: const Text('Hard'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => controller.grade(RecallGrade.good),
                          child: const Text('Good'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => controller.grade(RecallGrade.easy),
                          child: const Text('Easy'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
