import 'package:flutter_test/flutter_test.dart';
import 'package:veronica/main.dart';

void main() {
  testWidgets('app starts', (tester) async {
    await tester.pumpWidget(const VeronicaApp());
    expect(find.text('VERONICA'), findsOneWidget);
  });
}
