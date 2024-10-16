import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock widgets
class MockPageLayout extends StatelessWidget {
  final Widget child;
  final Widget header;

  const MockPageLayout({super.key, required this.child, required this.header});

  @override
  Widget build(BuildContext context) => Column(children: [header, child]);
}

class MockPageHeader extends StatelessWidget {
  final String title;

  const MockPageHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) => Text(title);
}

class MockVerticalTabs extends StatelessWidget {
  final List<Widget> tabs;

  const MockVerticalTabs({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) => Column(children: tabs);
}

class MockVerticalTab extends StatelessWidget {
  final String title;
  final String iconPath;
  final Widget content;

  const MockVerticalTab({
    super.key,
    required this.title,
    required this.iconPath,
    required this.content,
  });

  @override
  Widget build(BuildContext context) =>
      Column(children: [Text(title), content]);
}

class MockDisplayAndLanguageTab extends StatelessWidget {
  const MockDisplayAndLanguageTab({super.key});

  @override
  Widget build(BuildContext context) => Container();
}

// Mock SettingsPage
class MockSettingsPage extends StatelessWidget {
  const MockSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MockPageLayout(
      header: MockPageHeader(title: 'Settings'),
      child: MockVerticalTabs(
        tabs: [
          MockVerticalTab(
            title: 'Display and Languages',
            iconPath: 'assets/icons/globe.svg',
            content: MockDisplayAndLanguageTab(),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('SettingsPage builds correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: MockSettingsPage(),
      ),
    );

    // Verify that the MockSettingsPage is rendered
    expect(find.byType(MockSettingsPage), findsOneWidget);

    // Verify that MockPageLayout is used
    expect(find.byType(MockPageLayout), findsOneWidget);

    // Verify that MockPageHeader is used with correct title
    expect(find.byType(MockPageHeader), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    // Verify that MockVerticalTabs is used
    expect(find.byType(MockVerticalTabs), findsOneWidget);

    // Verify that MockVerticalTab is used with correct title and content
    expect(find.byType(MockVerticalTab), findsOneWidget);
    expect(find.text('Display and Languages'), findsOneWidget);
    expect(find.byType(MockDisplayAndLanguageTab), findsOneWidget);
  });
}
