import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/multi_filter.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_view_model_provider.dart';
import 'package:coach_app/l10n.dart';

/// A widget that provides a multi-filter interface for athlete filtering,
/// specifically for filtering by sports.
class AthleteMultiFilter extends ConsumerWidget {
  const AthleteMultiFilter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athletesViewModel = ref.watch(athletesViewModelProvider.notifier);

    final sportsViewModel = ref.watch(sportsViewModelProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MultiFilter(
          width: constraints.maxWidth,
          filters: [
            MultiFilterGroup(
              groupName: context.l10n.sports,
              groupId: 'sports',
              viewModelProvider: sportsViewModel,
              onSearchChanged: (query) =>
                  sportsViewModel.updateNameFilter(query),
              initialSearch: () => sportsViewModel.currentNameFilter ?? '',
              selectedOptions: athletesViewModel.currentSports ?? [],
              toFilterOption: (sport) =>
                  FilterOption(name: sport.name, id: sport.id),
            ),
          ],
          onApply: (filter) => ref
              .read(athletesViewModelProvider.notifier)
              .updateFilters(sports: filter['sports']),
          onClear: () {
            ref
                .read(athletesViewModelProvider.notifier)
                .updateFilters(sports: []);
            sportsViewModel.updateNameFilter('');
          },
        );
      },
    );
  }
}
