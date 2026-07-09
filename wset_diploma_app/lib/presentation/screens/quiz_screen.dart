import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';
import '../../domain/entities/quiz_session.dart';
import '../state/quiz_controller.dart';
import '../widgets/question_option_tile.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final WsetModule? module;

  const QuizScreen({super.key, this.module});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref
          .read(quizControllerProvider.notifier)
          .startAdaptiveSession(module: widget.module),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(quizControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Quiz')),
      body: stateAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not start quiz: $e')),
        data: (ui) {
          final session = ui.session;
          if (session == null || session.questions.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No questions available yet for this selection. Try syncing content or picking a different module.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (session.isComplete) {
            return _QuizSummary(session: session);
          }

          final question = session.currentQuestion!;
          return _QuestionView(question: question, ui: ui);
        },
      ),
    );
  }
}

class _QuestionView extends ConsumerWidget {
  final Question question;
  final QuizUiState ui;

  const _QuestionView({required this.question, required this.ui});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(quizControllerProvider.notifier);
    final singleChoice = question.type == QuestionType.singleChoice;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LinearProgressIndicator(
            value: ui.session!.answers.length / ui.session!.questions.length,
          ),
          const SizedBox(height: 12),
          Text(
            '${question.module.info.code} · Difficulty ${question.difficulty}/5',
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 8),
          Text(question.prompt, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                for (var i = 0; i < question.options.length; i++)
                  QuestionOptionTile(
                    text: question.options[i],
                    isSelected: ui.selectedOptionIndexes.contains(i),
                    revealed: ui.answerRevealed,
                    isCorrectOption: question.correctOptionIndexes.contains(i),
                    onTap: ui.answerRevealed
                        ? null
                        : () => controller.toggleOption(i,
                            singleChoice: singleChoice),
                  ),
                if (ui.answerRevealed) ...[
                  const SizedBox(height: 12),
                  Card(
                    color:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline),
                              const SizedBox(width: 8),
                              Text('Explanation',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const Spacer(),
                              if (ui.lastXpEarned > 0)
                                Text(
                                  '+${ui.lastXpEarned} XP',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(question.explanation),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: ui.answerRevealed
                  ? controller.nextQuestion
                  : (ui.selectedOptionIndexes.isEmpty
                      ? null
                      : controller.submitAnswer),
              child:
                  Text(ui.answerRevealed ? 'Next question' : 'Submit answer'),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizSummary extends StatelessWidget {
  final QuizSession session;

  const _QuizSummary({required this.session});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 64),
            const SizedBox(height: 16),
            Text(
              'Session complete: ${session.correctCount}/${session.questions.length} correct',
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
}
