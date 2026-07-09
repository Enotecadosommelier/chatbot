import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sat/sat_note_comparator.dart';
import '../state/sat_controller.dart';

/// A single built-in practice exercise so the SAT (Systematic Approach to
/// Tasting) simulator is usable without a real bottle in front of the
/// learner. In a full deployment this would offer a library of practice
/// wines; see docs/CONTENT_ROADMAP.md.
const _practiceModelNote = SatNote({
  SatField.clarity: 'clear',
  SatField.intensityAppearance: 'medium',
  SatField.colour: 'deep ruby',
  SatField.conditionNose: 'clean',
  SatField.intensityNose: 'pronounced',
  SatField.aromaCharacteristics:
      'blackberry, plum, violet, vanilla, black pepper',
  SatField.development: 'youthful',
  SatField.sweetness: 'dry',
  SatField.acidity: 'medium',
  SatField.tannin: 'medium+',
  SatField.alcohol: 'high',
  SatField.body: 'full',
  SatField.flavourIntensity: 'pronounced',
  SatField.flavourCharacteristics: 'blackberry, plum, vanilla, black pepper',
  SatField.finish: 'long',
});

const _fieldLabels = {
  SatField.clarity: 'Clarity',
  SatField.intensityAppearance: 'Intensity (appearance)',
  SatField.colour: 'Colour',
  SatField.conditionNose: 'Condition (nose)',
  SatField.intensityNose: 'Intensity (nose)',
  SatField.aromaCharacteristics: 'Aroma characteristics',
  SatField.development: 'Development',
  SatField.sweetness: 'Sweetness',
  SatField.acidity: 'Acidity',
  SatField.tannin: 'Tannin',
  SatField.alcohol: 'Alcohol',
  SatField.body: 'Body',
  SatField.flavourIntensity: 'Flavour intensity',
  SatField.flavourCharacteristics: 'Flavour characteristics',
  SatField.finish: 'Finish',
};

class SatSimulatorScreen extends ConsumerWidget {
  const SatSimulatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(satControllerProvider);
    final controller = ref.read(satControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('SAT Simulator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Practice wine: Malbec, Mendoza, Argentina (fictional example)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Fill in your own Systematic Approach to Tasting grid below, then '
                    'compare it against a model tasting note. Wine assessment is '
                    'subjective — use this as a study aid to check your terminology '
                    'and structure, not as an official grade.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          for (final field in _fieldLabels.keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TextField(
                decoration: InputDecoration(
                  labelText: _fieldLabels[field],
                  border: const OutlineInputBorder(),
                ),
                onChanged: (value) => controller.setField(field, value),
              ),
            ),
          FilledButton(
            onPressed: () => controller.compare(_practiceModelNote),
            child: const Text('Compare to model note'),
          ),
          if (uiState.report != null) ...[
            const SizedBox(height: 16),
            _ReportCard(report: uiState.report!),
          ],
        ],
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final SatComparisonReport report;

  const _ReportCard({required this.report});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alignment: ${(report.alignmentScore * 100).round()}% '
              '(${report.matchedCount}/${report.totalCount} fields)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            for (final result in report.fieldResults)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      result.matches ? Icons.check_circle : Icons.info_outline,
                      color: result.matches ? Colors.green : Colors.orange,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_fieldLabels[result.field]}: you said "${result.learnerValue}" '
                        '· model says "${result.modelValue}"',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
