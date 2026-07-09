import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wset_diploma_app/app.dart';

void main() {
  testWidgets('App shows the splash screen while local storage boots up',
      (WidgetTester tester) async {
    // A single pump (no pumpAndSettle) is intentional: appBootstrapProvider
    // opens the real sqflite database, which has no platform binding in a
    // plain widget test. We only assert on the synchronous "loading" frame
    // here; full end-to-end flows are covered by manual/device testing.
    await tester.pumpWidget(const ProviderScope(child: WsetDiplomaApp()));

    expect(find.text('WSET Diploma Prep'), findsWidgets);
  });
}
