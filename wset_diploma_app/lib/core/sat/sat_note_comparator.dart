/// SAT (Systematic Approach to Tasting) note comparison.
///
/// Wine tasting assessment is inherently subjective, so this does not
/// pretend to auto-grade a tasting note as "correct" or "incorrect".
/// Instead it compares the learner's structured SAT entry against a model
/// reference note field-by-field, for self-directed study feedback — the
/// same honest approach used by WSET's own specimen answers.
library sat_note_comparator;

enum SatField {
  clarity,
  intensityAppearance,
  colour,
  conditionNose,
  intensityNose,
  aromaCharacteristics,
  development,
  sweetness,
  acidity,
  tannin,
  alcohol,
  body,
  flavourIntensity,
  flavourCharacteristics,
  finish,
  qualityLevel,
}

class SatNote {
  final Map<SatField, String> values;
  const SatNote(this.values);
}

class SatFieldResult {
  final SatField field;
  final String learnerValue;
  final String modelValue;
  final bool matches;

  const SatFieldResult({
    required this.field,
    required this.learnerValue,
    required this.modelValue,
    required this.matches,
  });
}

class SatComparisonReport {
  final List<SatFieldResult> fieldResults;

  const SatComparisonReport(this.fieldResults);

  int get matchedCount => fieldResults.where((r) => r.matches).length;
  int get totalCount => fieldResults.length;
  double get alignmentScore => totalCount == 0 ? 0 : matchedCount / totalCount;
}

class SatNoteComparator {
  /// Compares [learnerNote] against [modelNote]. A field "matches" when the
  /// learner's answer, normalised (trimmed/lowercased), is contained in or
  /// equal to the model answer's accepted value — this keeps single-word
  /// grid answers (e.g. "medium+") comparable without requiring exact
  /// prose matches.
  SatComparisonReport compare(SatNote learnerNote, SatNote modelNote) {
    final results = <SatFieldResult>[];
    for (final field in modelNote.values.keys) {
      final modelValue = modelNote.values[field] ?? '';
      final learnerValue = learnerNote.values[field] ?? '';
      final matches = _normalise(learnerValue) == _normalise(modelValue) ||
          (_normalise(learnerValue).isNotEmpty &&
              _normalise(modelValue).contains(_normalise(learnerValue)));
      results.add(
        SatFieldResult(
          field: field,
          learnerValue: learnerValue,
          modelValue: modelValue,
          matches: matches,
        ),
      );
    }
    return SatComparisonReport(results);
  }

  String _normalise(String value) => value.trim().toLowerCase();
}
