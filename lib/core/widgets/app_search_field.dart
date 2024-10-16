import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/utils/debouncer.dart';

/// A reusable search field component for the app.
class AppSearchField extends ConsumerStatefulWidget {
  /// The function to call when the search query changes.
  final void Function(String) onSearchChanged;

  /// The initial search query.
  final String initialQuery;

  final double? width;

  const AppSearchField({
    super.key,
    required this.onSearchChanged,
    this.width,
    this.initialQuery = '',
  });

  @override
  ConsumerState<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends ConsumerState<AppSearchField>
    with DebounceMixin {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.length > 1) {
      getDebouncer().run(() {
        widget.onSearchChanged(query);
      });
    } else if (query.isEmpty) {
      widget.onSearchChanged('');
    }
  }

  @override
  Widget build(BuildContext context) {
    final outlinedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(context.isDesktop ? 22 : 10),
      borderSide: BorderSide(color: context.color.onSurface.withOpacity(.5)),
    );

    return SizedBox(
      height: 52,
      width: widget.width ?? 320,
      child: TextField(
        controller: _controller,
        onChanged: _onSearchChanged,
        maxLength: 20,
        buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) =>
            const SizedBox(),
        decoration: InputDecoration(
          hintText: context.l10n.search,
          filled: false,
          border: outlinedBorder,
          enabledBorder: outlinedBorder,
          focusedBorder: outlinedBorder,
          contentPadding: const EdgeInsets.fromLTRB(20, 14, 20, 1),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 5, 12),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              width: 20,
              height: 20,
            ),
          ),
        ),
      ),
    );
  }
}
