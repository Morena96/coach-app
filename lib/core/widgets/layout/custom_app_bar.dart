import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:coach_app/core/widgets/layout/online_offline_mode.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/providers/navbar_state_provider.dart';

/// A custom app bar widget that adapts to mobile and desktop layouts.
///
/// This widget implements [PreferredSizeWidget] to be used as an [AppBar].
/// It provides a responsive design that changes based on the screen size
/// and interacts with the navbar state for mobile menu functionality.
class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Creates a [CustomAppBar].
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.isMobile;
    final navbarState = ref.watch(navbarStateProvider);

    return AppBar(
      // Show menu/close button only on mobile
      leading: isMobile
          ? IconButton(
              icon: Icon(navbarState.expanded ? Icons.close : Icons.menu),
              onPressed: () {
                // Toggle the navbar expanded state
                ref.read(navbarStateProvider.notifier).state =
                    navbarState.copyWith(expanded: !navbarState.expanded);
              },
            )
          : null,
      title: Row(
        children: [
          OnlineOfflineMode(),
          // const Spacer(),
          // const Icon(Icons.mail),
          // const SizedBox(width: 18),
          // const Icon(Icons.notifications),
          // const SizedBox(width: 18),
          // Padding(
          //   padding: const EdgeInsets.only(top: 7),
          //   child: Text(
          //     context.l10n.profile,
          //     style: AppTextStyle.primary14b,
          //   ),
          // ),
          // // Adjust spacing based on layout
          SizedBox(width: isMobile ? 20 : 60),
        ],
      ),
      elevation: 0,
      // Add a subtle border at the bottom of the app bar
      shape: Border(
        bottom: BorderSide(
          color: context.color.onTertiary.withOpacity(.3),
          width: 1,
        ),
      ),
    );
  }

  /// The preferred size of the app bar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
