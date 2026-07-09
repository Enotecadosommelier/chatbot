import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/wset_modules.dart';
import '../state/feature_providers.dart';
import '../state/providers.dart';

class StudyPlanScreen extends ConsumerWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final planAsync = ref.watch(activeStudyPlanProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Study Plan')),
      body: planAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load study plan: $e')),
        data: (plan) {
          if (plan == null) {
            return _NoPlanView(
              onGenerate: (module, examDate) async {
                final userId = await ref.read(currentUserIdProvider.future);
                await ref.read(generateStudyPlanUseCaseProvider).call(
                      userId: userId,
                      targetModule: module,
                      examDate: examDate,
                    );
                ref.invalidate(activeStudyPlanProvider);
              },
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '${plan.daysRemaining} days until your ${plan.targetModule.info.code} exam',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: plan.completionRatio),
              const SizedBox(height: 16),
              for (final session in plan.sessions)
                Card(
                  child: CheckboxListTile(
                    value: session.completed,
                    title: Text(DateFormat.yMMMd().format(session.date)),
                    subtitle: Text(
                      '${session.focusTopicId} · ${session.plannedDuration.inMinutes} min',
                    ),
                    onChanged: (checked) async {
                      final userId =
                          await ref.read(currentUserIdProvider.future);
                      await ref
                          .read(studyPlanRepositoryProvider)
                          .markSessionCompleted(userId, session.date);
                      ref.invalidate(activeStudyPlanProvider);
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _NoPlanView extends StatefulWidget {
  final Future<void> Function(WsetModule module, DateTime examDate) onGenerate;

  const _NoPlanView({required this.onGenerate});

  @override
  State<_NoPlanView> createState() => _NoPlanViewState();
}

class _NoPlanViewState extends State<_NoPlanView> {
  WsetModule _module = WsetModule.d1;
  DateTime _examDate = DateTime.now().add(const Duration(days: 60));
  bool _generating = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Build a countdown study plan',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<WsetModule>(
            initialValue: _module,
            decoration: const InputDecoration(
                labelText: 'Target module', border: OutlineInputBorder()),
            items: WsetModule.values
                .map((m) =>
                    DropdownMenuItem(value: m, child: Text(m.info.title)))
                .toList(),
            onChanged: (m) => setState(() => _module = m ?? _module),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('Exam date'),
            subtitle: Text('${_examDate.toLocal()}'.split(' ').first),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _examDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 730)),
              );
              if (picked != null) setState(() => _examDate = picked);
            },
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _generating
                ? null
                : () async {
                    setState(() => _generating = true);
                    await widget.onGenerate(_module, _examDate);
                    if (mounted) setState(() => _generating = false);
                  },
            child: _generating
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Generate plan'),
          ),
        ],
      ),
    );
  }
}
