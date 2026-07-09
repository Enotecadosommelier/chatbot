import '../../core/sat/sat_note_comparator.dart';

/// Thin use-case wrapper around [SatNoteComparator] so presentation code
/// depends on the domain layer rather than reaching into core directly.
class CompareSatNoteUseCase {
  final SatNoteComparator comparator;

  CompareSatNoteUseCase({SatNoteComparator? comparator})
      : comparator = comparator ?? SatNoteComparator();

  SatComparisonReport call(
      {required SatNote learnerNote, required SatNote modelNote}) {
    return comparator.compare(learnerNote, modelNote);
  }
}
