import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/multi_filter.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_view_model_provider.dart';
import 'package:coach_app/features/sessions/presentation/providers/sessions_view_model_provider.dart';
import 'package:coach_app/l10n.dart';

class SessionMultiFilter extends ConsumerWidget {
  const SessionMultiFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionsViewModel =
        ref.watch(sessionsViewModelProvider(null).notifier);
    final sportsViewModel = ref.watch(sportsViewModelProvider.notifier);
    final athletesViewModel = ref.watch(athletesViewModelProvider.notifier);
    final groupsViewModel = ref.watch(groupsViewModelProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MultiFilter(
          width: constraints.maxWidth,
          filters: [
            MultiFilterGroup(
              groupName: context.l10n.athletes,
              groupId: 'athletes',
              viewModelProvider: athletesViewModel,
              selectedOptions: sessionsViewModel.currentAthletes ?? [],
              onSearchChanged: (query) =>
                  athletesViewModel.updateNameFilter(query),
              initialSearch: () => athletesViewModel.currentNameFilter ?? '',
              toFilterOption: (athlete) =>
                  FilterOption(name: athlete.name, id: athlete.id),
            ),
            MultiFilterGroup(
              groupName: context.l10n.sports,
              groupId: 'sports',
              viewModelProvider: sportsViewModel,
              onSearchChanged: (query) =>
                  sportsViewModel.updateNameFilter(query),
              initialSearch: () => sportsViewModel.currentNameFilter ?? '',
              selectedOptions: sessionsViewModel.currentSports ?? [],
              toFilterOption: (sport) =>
                  FilterOption(name: sport.name, id: sport.id),
            ),
            MultiFilterGroup(
              groupName: context.l10n.groups,
              groupId: 'groups',
              viewModelProvider: groupsViewModel,
              onSearchChanged: (query) =>
                  groupsViewModel.updateNameFilter(query),
              initialSearch: () => groupsViewModel.currentNameFilter ?? '',
              selectedOptions: sessionsViewModel.currentGroups ?? [],
              toFilterOption: (group) =>
                  FilterOption(name: group.name, id: group.id),
            ),
          ],
          onApply: (filter) => ref
              .read(sessionsViewModelProvider(null).notifier)
              .updateFilters(
                  sports: filter['sports'],
                  athletes: filter['athletes'],
                  groups: filter['groups']),
          onClear: () {
            ref
                .read(sessionsViewModelProvider(null).notifier)
                .updateFilters(sports: [], athletes: [], groups: []);
            athletesViewModel.updateNameFilter('');
            groupsViewModel.updateNameFilter('');
            sportsViewModel.updateNameFilter('');
          },
        );
      },
    );
  }
}
