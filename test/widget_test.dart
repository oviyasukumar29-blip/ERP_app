import 'package:flutter_test/flutter_test.dart';

import 'package:pinesphere_erp/main.dart';

void main() {
  testWidgets('Pinesphere ERP login loads', (WidgetTester tester) async {
    await tester.pumpWidget(const PinesphereErpApp());

    expect(find.text('Learn. Manage. Grow.'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Super Admin'), findsOneWidget);
  });
}
