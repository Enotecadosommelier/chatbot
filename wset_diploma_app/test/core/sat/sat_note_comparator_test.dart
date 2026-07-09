import 'package:flutter_test/flutter_test.dart';
import 'package:wset_diploma_app/core/sat/sat_note_comparator.dart';

void main() {
  group('SatNoteComparator', () {
    final comparator = SatNoteComparator();

    test('exact-match fields count as matched', () {
      const model = SatNote({SatField.acidity: 'medium+'});
      const learner = SatNote({SatField.acidity: 'medium+'});
      final report = comparator.compare(learner, model);
      expect(report.matchedCount, 1);
      expect(report.alignmentScore, 1.0);
    });

    test('case/whitespace differences still match', () {
      const model = SatNote({SatField.tannin: 'Medium'});
      const learner = SatNote({SatField.tannin: '  medium  '});
      final report = comparator.compare(learner, model);
      expect(report.fieldResults.single.matches, isTrue);
    });

    test('mismatched fields are reported but do not throw', () {
      const model = SatNote({SatField.body: 'full'});
      const learner = SatNote({SatField.body: 'light'});
      final report = comparator.compare(learner, model);
      expect(report.matchedCount, 0);
      expect(report.alignmentScore, 0.0);
    });

    test('missing learner field is treated as unmatched, not a crash', () {
      const model = SatNote({SatField.finish: 'long'});
      const learner = SatNote({});
      final report = comparator.compare(learner, model);
      expect(report.fieldResults.single.matches, isFalse);
      expect(report.fieldResults.single.learnerValue, '');
    });

    test('alignment score averages across multiple fields', () {
      const model = SatNote({
        SatField.acidity: 'high',
        SatField.alcohol: 'medium',
        SatField.body: 'full',
        SatField.finish: 'long',
      });
      const learner = SatNote({
        SatField.acidity: 'high',
        SatField.alcohol: 'medium',
        SatField.body: 'light',
        SatField.finish: 'short',
      });
      final report = comparator.compare(learner, model);
      expect(report.matchedCount, 2);
      expect(report.alignmentScore, 0.5);
    });
  });
}
