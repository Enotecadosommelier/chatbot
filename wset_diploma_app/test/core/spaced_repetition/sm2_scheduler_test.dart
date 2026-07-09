import 'package:flutter_test/flutter_test.dart';
import 'package:wset_diploma_app/core/spaced_repetition/sm2_scheduler.dart';

void main() {
  group('Sm2Scheduler', () {
    late Sm2Scheduler scheduler;
    final start = DateTime(2026, 1, 1);

    setUp(() {
      scheduler = Sm2Scheduler();
    });

    test('initial state has EF 2.5 and 0 repetitions', () {
      final state = SrsCardState.initial(now: start);
      expect(state.easinessFactor, 2.5);
      expect(state.repetitions, 0);
      expect(state.intervalDays, 0);
    });

    test('first "good" review schedules a 1-day interval', () {
      final state = SrsCardState.initial(now: start);
      final next = scheduler.schedule(state, RecallGrade.good, now: start);
      expect(next.repetitions, 1);
      expect(next.intervalDays, 1);
      expect(next.dueAt, start.add(const Duration(days: 1)));
    });

    test('second consecutive "good" review schedules a 6-day interval', () {
      var state = SrsCardState.initial(now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      expect(state.repetitions, 2);
      expect(state.intervalDays, 6);
    });

    test('third+ "good" review multiplies interval by easiness factor', () {
      var state = SrsCardState.initial(now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      final efBeforeThird = state.easinessFactor;
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      expect(state.repetitions, 3);
      expect(state.intervalDays, (6 * efBeforeThird).round());
    });

    test('"again" (lapse) resets repetitions and schedules a 1-day interval',
        () {
      var state = SrsCardState.initial(now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      state = scheduler.schedule(state, RecallGrade.good, now: start);
      expect(state.repetitions, 2);

      state = scheduler.schedule(state, RecallGrade.again, now: start);
      expect(state.repetitions, 0);
      expect(state.intervalDays, 1);
      expect(state.dueAt, start.add(const Duration(days: 1)));
    });

    test('easiness factor never drops below 1.3', () {
      var state = SrsCardState.initial(now: start);
      for (var i = 0; i < 20; i++) {
        state = scheduler.schedule(state, RecallGrade.again, now: start);
      }
      expect(state.easinessFactor, greaterThanOrEqualTo(1.3));
    });

    test('"easy" grade increases easiness factor relative to "good"', () {
      final state = SrsCardState.initial(now: start);
      final goodState = scheduler.schedule(state, RecallGrade.good, now: start);
      final easyState = scheduler.schedule(state, RecallGrade.easy, now: start);
      expect(easyState.easinessFactor, greaterThan(goodState.easinessFactor));
    });

    test('repeated "hard" grades slowly reduce easiness factor', () {
      var state = SrsCardState.initial(now: start);
      final initialEf = state.easinessFactor;
      state = scheduler.schedule(state, RecallGrade.hard, now: start);
      expect(state.easinessFactor, lessThan(initialEf));
    });
  });
}
