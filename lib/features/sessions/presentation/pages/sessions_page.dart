import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_search_field.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/range_calendar.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/features/sessions/presentation/widgets/session_list_view.dart';
import 'package:coach_app/features/sessions/presentation/widgets/session_multi_filter.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/constants/app_constants.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// Displays a page for viewing and managing saved sessions
class SessionsPage extends ConsumerStatefulWidget {
  const SessionsPage({super.key});

  @override
  ConsumerState<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends ConsumerState<SessionsPage>
    with SingleTickerProviderStateMixin {
  /// Unique key for the page to force rebuild when filters are reset
  Key _pageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return KeyedSubtree(
        key: _pageKey,
        child: DefaultTabController(
          length: 2,
          child: PageLayout(
            header: PageHeader(
              title: context.l10n.savedSessions,
              subtitle: constraints.maxWidth > AppConstants.desktopBreakpoint
                  ? _buildDesktopHeader()
                  : _buildMobileHeader(),
            ),
            child: const SessionListView(),
          ),
        ),
      );
    });
  }

  /// Builds the header layout for desktop view
  Widget _buildDesktopHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _searchField(),
        const Spacer(),
        const SizedBox(width: 12),
        _buildRangeCalendar(),
        const SizedBox(width: 12),
        const SessionMultiFilter(),
        const SizedBox(width: 4),
        _clearButton(),
      ],
    );
  }

  /// Builds the header layout for mobile view
  Widget _buildMobileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _searchField()),
            const SizedBox(width: 8),
            const SessionMultiFilter(),
          ],
        ),
        _buildRangeCalendar(),
      ],
    );
  }

  /// Builds the range calendar widget
  Widget _buildRangeCalendar() {
    return RangeCalendar(
      selectedRange:
          ref.read(sessionsViewModelProvider(null).notifier).currentDateRange,
      onDateSelected: (fromDate, toDate) => ref
          .read(sessionsViewModelProvider(null).notifier)
          .updateDateRange(fromDate: fromDate, toDate: toDate),
    );
  }

  /// Builds the clear filters button
  Widget _clearButton() => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: ref
                .watch(sessionsViewModelProvider(null).notifier)
                .hasActiveFiltersNotifier,
            builder: (context, hasActiveFilters, _) {
              return hasActiveFilters
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: _resetFilters,
                        child: Text(
                          context.l10n.clearFilters,
                          style: AppTextStyle.primary14b
                              .copyWith(color: context.color.onSurface),
                        ),
                      ),
                    )
                  : const SizedBox();
            },
          );
        },
      );

  /// Resets all active filters
  void _resetFilters() {
    setState(() => _pageKey = UniqueKey());
    ref.read(sessionsViewModelProvider(null).notifier).clearAllFilters();
  }

  /// Builds the search field widget
  Widget _searchField() => AppSearchField(
        initialQuery: ref
                .read(sessionsViewModelProvider(null).notifier)
                .currentTitleFilter ??
            '',
        onSearchChanged: (query) {
          ref
              .read(sessionsViewModelProvider(null).notifier)
              .updateNameFilter(query);
        },
      );
}
