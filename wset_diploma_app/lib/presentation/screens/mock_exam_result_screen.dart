import 'package:flutter/material.dart';

import '../../domain/entities/quiz_session.dart';

class MockExamResultScreen extends StatelessWidget {
  final QuizSession session;

  const MockExamResultScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final scorePercent = (session.scoreRatio * 100).round();
    final passed = scorePercent >= 55;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              passed ? Icons.emoji_events : Icons.refresh,
              size: 72,
              color: passed ? Colors.amber : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text('$scorePercent%',
                style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 8),
            Text(
              '${session.correctCount} / ${session.questions.length} correct',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              passed
                  ? 'Above the typical 55% pass mark — keep it up.'
                  : 'Below the typical 55% pass mark — review your weakest topics and try again.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Back to home'),
            ),
          ],
        ),
      ),
    );
  }
}
