// Basic widget test for Cozy Planner.
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cozy_planner/app.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CozyPlannerApp()));
    // Just verify the app renders without error
    expect(find.text('Cozy Planner'), findsOneWidget);
  });
}
