import 'package:flutter/material.dart';

class BreadcrumbProvider extends InheritedWidget {
  final Map<String, String> customTitles;

  const BreadcrumbProvider({
    super.key,
    required this.customTitles,
    required super.child,
  });

  static BreadcrumbProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BreadcrumbProvider>();
  }

  @override
  bool updateShouldNotify(BreadcrumbProvider oldWidget) {
    return customTitles != oldWidget.customTitles;
  }
}
