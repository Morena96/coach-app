import 'package:flutter/material.dart';

/// Represents an item in a breadcrumb navigation.
class BreadcrumbItem {
  /// The text label for the breadcrumb item.
  final String label;

  /// The callback function to be executed when the item is tapped.
  final VoidCallback? onTap;

  /// Constructs a [BreadcrumbItem] with the given [label] and optional [onTap] callback.
  BreadcrumbItem({
    required this.label,
    this.onTap,
  });
}
