import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/l10n.dart';
import 'package:flutter/material.dart';

/// Enumerates the available navigation items in the app.
///
/// Each item includes a title, an identifier, and an associated route.
enum NavbarItem {
  dashboard('dashboard', Routes.home),
  data('data', Routes.data),
  groups('groups', Routes.groups),
  athletes('athletes', Routes.athletes),
  reports('reports', Routes.reports),
  liveSession('live-session', Routes.liveSession),
  sessions('sessions', Routes.sessions),
  videoExport('video-export', Routes.videoExport),
  alerts('alerts', Routes.alerts),
  settings('settings', Routes.settings);

  /// The unique identifier for the navigation item.
  final String id;

  /// The associated route for the navigation item.
  final Routes route;

  const NavbarItem(this.id, this.route);

  String title(BuildContext context) {
    switch (this) {
      case NavbarItem.dashboard:
        return context.l10n.dashboard;
      case NavbarItem.data:
        return context.l10n.data;
      case NavbarItem.groups:
        return context.l10n.groups;
      case NavbarItem.athletes:
        return context.l10n.athletes;
      case NavbarItem.reports:
        return context.l10n.reports;
      case NavbarItem.liveSession:
        return context.l10n.liveSession;
      case NavbarItem.sessions:
        return context.l10n.savedSessions;
      case NavbarItem.videoExport:
        return context.l10n.videoExport;
      case NavbarItem.alerts:
        return context.l10n.alerts;
      case NavbarItem.settings:
        return context.l10n.settings;
    }
  }
}
