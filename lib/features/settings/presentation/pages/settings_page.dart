import 'package:coach_app/features/settings/presentation/pages/logs_tab.dart';
import 'package:flutter/material.dart';

import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/layout/vertical_tabs.dart';
import 'package:coach_app/features/settings/presentation/pages/display_and_language_tab.dart';
import 'package:coach_app/l10n.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      header: PageHeader(
        title: context.l10n.settings,
      ),
      child: VerticalTabs(
        tabs: [
          VerticalTab(
            title: context.l10n.displayAndLanguages,
            iconPath: 'assets/icons/globe.svg',
            content: const DisplayAndLanguageTab(),
          ),
          VerticalTab(
            title: context.l10n.logs,
            iconPath: 'assets/icons/pen.svg',
            content: const LogsTab(),
          ),
        ],
      ),
    );
  }
}
