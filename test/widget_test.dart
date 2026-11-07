import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/app/app.dart';

import 'helpers/app.dart';

void main() {
  testWidgets('app opens on Today with the tab bar', (tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: (await tester.runAsync(testContainer))!,
        child: const VeronicaApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Today'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Tasks'));
    await tester.pumpAndSettle();
    expect(find.text('Tasks'), findsWidgets);
  });
}
