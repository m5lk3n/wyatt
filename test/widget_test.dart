import 'package:flutter_test/flutter_test.dart';

import 'package:wyatt/main.dart';

void main() {
  testWidgets('wyatt smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WyattApp());
    expect(find.text('Wyatt Setup'), findsOneWidget);
  });
}
