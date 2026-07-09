import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';
import '../state/mock_exam_controller.dart';
import '../state/providers.dart';
import '../widgets/question_option_tile.dart';
import 'mock_exam_result_screen.dart';

class MockExamScreen extends ConsumerStatefulWidget {
  const MockExamScreen({super.key});

  @override
  ConsumerState<MockExamScreen> createState() => _MockExamScreenState();
}

class _MockExamScreenState extends ConsumerState<MockExamScreen> {
  List<int> _selected = [];
  DateTime _questionStartedAt = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(mockExamControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mock Exam')),
      body: examAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load exam: $e')),
        data: (session) {
          if (session == null) {
            return _ModulePicker(
              onPicked: (module) => ref
                  .read(mockExamControllerProvider.notifier)
                  .generate(module),
            );
          }

          if (session.finishedAt != null || session.isComplete) {
            return MockExamResultScreen(session: session);
          }

          final question = session.currentQuestion!;
          final singleChoice = question.type == QuestionType.singleChoice;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: session.answers.length / session.questions.length,
                ),
                const SizedBox(height: 8),
                Text(
                  'Question ${session.answers.length + 1} of ${session.questions.length}',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 8),
                Text(question.prompt,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: [
                      for (var i = 0; i < question.options.length; i++)
                        QuestionOptionTile(
                          text: question.options[i],
                          isSelected: _selected.contains(i),
                          revealed: false,
                          isCorrectOption: false,
                          onTap: () => setState(() {
                            if (singleChoice) {
                              _selected = [i];
                            } else if (_selected.contains(i)) {
                              _selected = [..._selected]..remove(i);
                            } else {
                              _selected = [..._selected, i];
                            }
                          }),
                        ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selected.isEmpty
                        ? null
                        : () async {
                            final userId =
                                await ref.read(currentUserIdProvider.future);
                            final timeTaken =
                                DateTime.now().difference(_questionStartedAt);
                            await ref
                                .read(mockExamControllerProvider.notifier)
                                .submitAnswer(
                                  userId: userId,
                                  selectedOptionIndexes: _selected,
                                  timeTaken: timeTaken,
                                );
                            setState(() {
                              _selected = [];
                              _questionStartedAt = DateTime.now();
                            });
                          },
                    child: const Text('Submit & continue'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ModulePicker extends StatelessWidget {
  final void Function(WsetModule) onPicked;

  const _ModulePicker({required this.onPicked});

  @override
  Widget build(BuildContext context) {
    final examModules =
        WsetModule.values.where((m) => m != WsetModule.d6).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Choose a module for a full-length, exam-shaped mock paper.',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 16),
        ...examModules.map(
          (module) => Card(
            child: ListTile(
              title: Text(module.info.title),
              subtitle: Text(module.info.assessmentFormat),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onPicked(module),
            ),
          ),
        ),
      ],
    );
  }
}
