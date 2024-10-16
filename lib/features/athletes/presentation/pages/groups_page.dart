import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/app_search_field.dart';
import 'package:coach_app/core/widgets/layout/page_header.dart';
import 'package:coach_app/core/widgets/layout/page_layout.dart';
import 'package:coach_app/core/widgets/primary_button.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/widgets/groups_grid_view.dart';
import 'package:coach_app/features/athletes/presentation/widgets/groups_multi_filter.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

class GroupsPage extends ConsumerStatefulWidget {
  const GroupsPage({super.key});

  @override
  ConsumerState<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends ConsumerState<GroupsPage> {
  Key _pageKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: _pageKey,
      child: PageLayout(
        header: PageHeader(
          title: context.l10n.groups,
          titleWidget: SizedBox(
            width: 150,
            child: PrimaryButton.add(
              label: context.l10n.createNewGroup,
              onPressed: () => context.push(Routes.groupsCreate.path),
            ),
          ),
          subtitle: context.isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _searchField(),
                    const SizedBox(width: 12),
                    const GroupsMultiFilter(),
                    const SizedBox(width: 4),
                    _clearButton()
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _searchField()),
                        const SizedBox(width: 12),
                        const GroupsMultiFilter(),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     const Expanded(child: GroupsMultiFilter()),
                    //     _clearButton()
                    //   ],
                    // ),
                  ],
                ),
        ),
        child: const GroupsGridView(),
      ),
    );
  }

  Widget _clearButton() => Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return ValueListenableBuilder(
            valueListenable: ref
                .watch(groupsViewModelProvider.notifier)
                .hasActiveFiltersNotifier,
            builder: (context, hasActiveFilters, _) {
              return hasActiveFilters
                  ? Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: TextButton(
                        onPressed: () {
                          setState(() => _pageKey = UniqueKey());
                          ref
                              .read(groupsViewModelProvider.notifier)
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
            ref.read(groupsViewModelProvider.notifier).currentNameFilter ?? '',
        onSearchChanged: (query) {
          ref.read(groupsViewModelProvider.notifier).updateNameFilter(query);
        },
      );
}
