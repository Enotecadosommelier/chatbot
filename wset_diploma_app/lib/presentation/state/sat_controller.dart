import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sat/sat_note_comparator.dart';
import 'providers.dart';

class SatUiState {
  final Map<SatField, String> learnerValues;
  final SatComparisonReport? report;

  const SatUiState({this.learnerValues = const {}, this.report});

  SatUiState copyWith(
      {Map<SatField, String>? learnerValues, SatComparisonReport? report}) {
    return SatUiState(
      learnerValues: learnerValues ?? this.learnerValues,
      report: report ?? this.report,
    );
  }
}

class SatController extends StateNotifier<SatUiState> {
  final Ref ref;

  SatController(this.ref) : super(const SatUiState());

  void setField(SatField field, String value) {
    final updated = {...state.learnerValues, field: value};
    state = SatUiState(learnerValues: updated);
  }

  void compare(SatNote modelNote) {
    final report = ref.read(compareSatNoteUseCaseProvider).call(
          learnerNote: SatNote(state.learnerValues),
          modelNote: modelNote,
        );
    state = state.copyWith(report: report);
  }

  void reset() {
    state = const SatUiState();
  }
}

final satControllerProvider =
    StateNotifierProvider.autoDispose<SatController, SatUiState>(
        (ref) => SatController(ref));
