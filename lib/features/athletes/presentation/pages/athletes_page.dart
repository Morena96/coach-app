import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_search_field.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_list_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/athlete_multi_filter.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that represents the Athletes page in the application.
///
/// This page displays a list of athletes and provides functionality
/// to add new athletes and filter the list.
class AthletesPage extends ConsumerStatefulWidget {
  const AthletesPage({super.key});

  @override
  ConsumerState<AthletesPage> createState() => _AthletesPageState();
}

class _AthletesPageState extends ConsumerState<AthletesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Key _pageKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    final viewModel = ref.read(athletesViewModelProvider.notifier);
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: viewModel.currentArchivedFilter ? 1 : 0,
    );
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final viewModel = ref.read(athletesViewModelProvider.notifier);
      viewModel.updateArchivedFilter(isArchived: _tabController.index == 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AthletesViewModel>(athletesViewModelProvider.notifier,
        (_, viewModel) {
      final newIndex = viewModel.currentArchivedFilter ? 1 : 0;
      if (_tabController.index != newIndex) {
        _tabController.animateTo(newIndex);
      }
    });

    return KeyedSubtree(
      key: _pageKey,
      child: DefaultTabController(
        length: 2,
        child: PageLayout(
          header: PageHeader(
            title: context.l10n.athleteList,
            titleWidget: SizedBox(
              width: context.isMobile ? 130 : null,
              child: PrimaryButton.add(
                label: context.l10n.addNewAthlete,
                onPressed: () => context.push(Routes.athletesCreate.path),
              ),
            ),
            subtitle: context.isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabs(context),
                      const Spacer(),
                      _searchField(),
                      const SizedBox(width: 12),
                      const AthleteMultiFilter(),
                      const SizedBox(width: 4),
                      _clearButton(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _searchField()),
                          const SizedBox(width: 12),
                          const AthleteMultiFilter(),
                        ],
                      ),
                      _buildTabs(context),
                    ],
                  ),
          ),
          child: const AthleteListView(),
        ),
      ),
    );
  }

  SizedBox _buildTabs(BuildContext context) {
    return SizedBox(
      width: 190,
      child: TabBar(
        controller: _tabController,
        onTap: (index) => ref
            .read(athletesViewModelProvider.notifier)
            .updateArchivedFilter(isArchived: index == 1),
        tabs: [
          Tab(child: Text(context.l10n.actual)),
          Tab(child: Text(context.l10n.archived)),
        ],
      ),
    );
  }

  Widget _clearButton() => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: ref
                .watch(athletesViewModelProvider.notifier)
                .hasActiveFiltersNotifier,
            builder: (context, hasActiveFilters, _) {
              return hasActiveFilters
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _pageKey = UniqueKey());
                          ref
                              .read(athletesViewModelProvider.notifier)
                              .clearAllFilters();
                        },
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

  Widget _searchField() => AppSearchField(
        initialQuery:
            ref.read(athletesViewModelProvider.notifier).currentNameFilter ??
                '',
        onSearchChanged: (query) {
          ref.read(athletesViewModelProvider.notifier).updateNameFilter(query);
        },
      );
}
