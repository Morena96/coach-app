import 'package:coach_app/shared/utils/debouncer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Test widget that uses DebounceMixin
class TestWidget extends StatefulWidget {
  final VoidCallback onBuild;

  const TestWidget({super.key, required this.onBuild});

  @override
  TestWidgetState createState() => TestWidgetState();
}

class TestWidgetState extends State<TestWidget> with DebounceMixin {
  void debouncedAction(VoidCallback action) {
    getDebouncer().run(action);
  }

  @override
  Widget build(BuildContext context) {
    widget.onBuild();
    return Container();
  }
}

void main() {
  group('Debouncer Tests', () {
    test('Debouncer runs action after specified delay', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      int counter = 0;

      debouncer.run(() => counter++);
      expect(counter, 0);

      await Future.delayed(const Duration(milliseconds: 110));
      expect(counter, 1);
    });

    test('Debouncer cancels previous action when called again', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      int counter = 0;

      debouncer.run(() => counter++);
      debouncer.run(() => counter += 2);

      await Future.delayed(const Duration(milliseconds: 110));
      expect(counter, 2);
    });

    test('Debouncer cancel method stops pending action', () async {
      final debouncer = Debouncer(delay: const Duration(milliseconds: 100));
      int counter = 0;

      debouncer.run(() => counter++);
      debouncer.cancel();

      await Future.delayed(const Duration(milliseconds: 110));
      expect(counter, 0);
    });
  });

  group('DebounceMixin Tests', () {
    testWidgets('DebounceMixin creates and uses Debouncer correctly',
        (WidgetTester tester) async {
      int counter = 0;
      int buildCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(
            onBuild: () => buildCount++,
          ),
        ),
      );

      final TestWidgetState state = tester.state(find.byType(TestWidget));

      state.debouncedAction(() => counter++);
      expect(counter, 0);
      expect(buildCount, 1);

      await tester.pump(const Duration(milliseconds: 310));
      expect(counter, 1);
      expect(buildCount, 1);
    });

    testWidgets('DebounceMixin cancels Debouncer on dispose',
        (WidgetTester tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(
            onBuild: () {},
          ),
        ),
      );

      final TestWidgetState state = tester.state(find.byType(TestWidget));

      state.debouncedAction(() => counter++);

      // Dispose the widget
      await tester.pumpWidget(Container());

      // Wait for more than the default debounce duration
      await tester.pump(const Duration(milliseconds: 310));

      // The counter should still be 0 because the debouncer was cancelled on dispose
      expect(counter, 0);
    });

    testWidgets('DebounceMixin uses custom delay', (WidgetTester tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: TestWidget(
            onBuild: () {},
          ),
        ),
      );

      final TestWidgetState state = tester.state(find.byType(TestWidget));

      state
          .getDebouncer(delay: const Duration(milliseconds: 500))
          .run(() => counter++);

      // Wait for less than the custom delay
      await tester.pump(const Duration(milliseconds: 400));
      expect(counter, 0);

      // Wait for the remainder of the custom delay
      await tester.pump(const Duration(milliseconds: 110));
      expect(counter, 1);
    });
  });
}
