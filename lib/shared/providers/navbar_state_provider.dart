import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/router/navbar_item.dart';
import 'package:coach_app/shared/constants/app_constants.dart';

final navbarStateProvider = StateProvider<NavbarState>(
  (ref) {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final width = view.physicalSize.width / view.devicePixelRatio;
    return NavbarState(
      expanded: width > AppConstants.mobileBreakpoint,
      selectedItem: NavbarItem.dashboard.id,
    );
  },
);

class NavbarState {
  final bool expanded;
  final String selectedItem;

  NavbarState({
    required this.expanded,
    required this.selectedItem,
  });

  NavbarState copyWith({
    bool? expanded,
    String? selectedItem,
  }) =>
      NavbarState(
        expanded: expanded ?? this.expanded,
        selectedItem: selectedItem ?? this.selectedItem,
      );
}
