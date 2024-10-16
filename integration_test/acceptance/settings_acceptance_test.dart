import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:coach_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Settings Acceptance Tests', () {
    testWidgets(
        'A user can load the application and it defaults to the dashboard page',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Simulate a delay to see the app's initial state
      await tester.pump(const Duration(seconds: 2));

      // Verify we're on the dashboard page
      expect(find.text('Home Page'), findsOneWidget);

      // Final delay to observe the settings page
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
