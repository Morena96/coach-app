import 'package:coach_app/features/hello_world/presentation/pages/map_page.dart';
import 'package:coach_app/features/sessions/presentation/pages/sessions_page.dart';
import 'package:coach_app/features/sessions/presentation/models/session_with_group_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/widgets/layout/app_layout.dart';
import 'package:coach_app/features/antenna_system/presentation/pages/antenna_control_page.dart';
import 'package:coach_app/features/antenna_system/presentation/pages/antenna_debug_page.dart';
import 'package:coach_app/features/antenna_system/presentation/pages/antenna_system_page.dart';
import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/athletes/presentation/pages/athlete_form_page.dart';
import 'package:coach_app/features/athletes/presentation/pages/athlete_view_page.dart';
import 'package:coach_app/features/athletes/presentation/pages/athletes_page.dart';
import 'package:coach_app/features/athletes/presentation/pages/group_form_page.dart';
import 'package:coach_app/features/athletes/presentation/pages/group_view_page.dart';
import 'package:coach_app/features/athletes/presentation/pages/groups_page.dart';
import 'package:coach_app/features/auth/presentation/pages/login_page.dart';
import 'package:coach_app/features/hello_world/hello_world.dart';
import 'package:coach_app/features/hello_world/presentation/pages/view_sample_gps_data.dart';
import 'package:coach_app/features/home/home.dart';
import 'package:coach_app/features/other/not_found_screen.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';
import 'package:coach_app/features/sessions/presentation/pages/session_view_page.dart';
import 'package:coach_app/features/sessions/presentation/pages/sessions_page.dart';
import 'package:coach_app/features/settings/presentation/pages/settings_page.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootKey,
    initialLocation: Routes.home.path,
    routes: <RouteBase>[
      fadeGoRoute(
        path: Routes.login.path,
        name: Routes.login.name,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      fadeGoRoute(
        path: Routes.helloWorld.path,
        name: Routes.helloWorld.name,
        builder: (BuildContext context, GoRouterState state) =>
            const HelloWorldPage(),
      ),
      fadeGoRoute(
        path: Routes.map.path,
        name: Routes.map.name,
        builder: (BuildContext context, GoRouterState state) => const MapPage(),
      ),
      fadeGoRoute(
        path: Routes.viewSampleGpsData.path,
        name: Routes.viewSampleGpsData.name,
        builder: (BuildContext context, GoRouterState state) =>
            const ViewSampleGpsData(),
      ),
      fadeGoRoute(
        path: Routes.antennaSystem.path,
        name: Routes.antennaSystem.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AntennaSystemPage(),
      ),
      fadeGoRoute(
        path: Routes.antennaDebug.path,
        name: Routes.antennaDebug.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AntennaDebugPage(),
      ),
      fadeGoRoute(
        path: Routes.antennaControl.path,
        name: Routes.antennaControl.name,
        builder: (BuildContext context, GoRouterState state) =>
            const AntennaControlPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => AppLayout(child: child),
        routes: [
          fadeGoRoute(
            path: Routes.home.path,
            builder: (context, state) => const HomePage(),
          ),
          fadeGoRoute(
              path: Routes.groups.path,
              builder: (context, state) => const GroupsPage(),
              routes: [
                fadeGoRoute(
                  path: 'create',
                  name: Routes.groupsCreate.name,
                  builder: (context, state) => const GroupFormPage(),
                ),
                fadeGoRoute(
                  path: '${Routes.groupDetails.path.split('/').last}/edit',
                  name: Routes.groupsEdit.name,
                  builder: (context, state) {
                    final group = state.extra as GroupView?;
                    return GroupFormPage(group: group);
                  },
                ),
                fadeGoRoute(
                  path: Routes.groupDetails.path.split('/').last,
                  name: Routes.groupDetails.name,
                  builder: (context, state) => GroupViewPage(
                    group: state.extra as GroupView,
                  ),
                ),
                fadeGoRoute(
                  path:
                      '${Routes.groupDetails.path.split('/').last}/:sessionId',
                  name: Routes.groupSessionDetails.name,
                  builder: (context, state) {
                    final sessionWithGroup =
                        state.extra as SessionWithGroupView;
                    return SessionViewPage(
                      session: sessionWithGroup.session,
                      group: sessionWithGroup.group,
                    );
                  },
                ),
              ]),
          fadeGoRoute(
            path: Routes.athletes.path,
            builder: (context, state) => const AthletesPage(),
            routes: [
              fadeGoRoute(
                path: 'create',
                name: Routes.athletesCreate.name,
                builder: (context, state) => const AthleteFormPage(),
              ),
              fadeGoRoute(
                path: '${Routes.athleteDetails.path.split('/').last}/edit',
                name: Routes.athletesEdit.name,
                builder: (context, state) {
                  final athlete = state.extra as AthleteView?;
                  return AthleteFormPage(athlete: athlete);
                },
              ),
              fadeGoRoute(
                path: Routes.athleteDetails.path.split('/').last,
                name: Routes.athleteDetails.name,
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return AthleteViewPage(
                    athleteId: id,
                    athleteName:
                        (state.extra as Map<String, String>?)?['athleteName'] ??
                            '',
                  );
                },
              ),
            ],
          ),
          // fadeGoRoute(
          //   path: Routes.reports.path,
          //   builder: (context, state) => const SizedBox(),
          // ),
          // fadeGoRoute(
          //   path: Routes.liveSession.path,
          //   builder: (context, state) => const SizedBox(),
          // ),
          fadeGoRoute(
            path: Routes.sessions.path,
            builder: (context, state) => const SessionsPage(),
            routes: [
              fadeGoRoute(
                path: Routes.sessionDetails.path.split('/').last,
                name: Routes.sessionDetails.name,
                builder: (context, state) => SessionViewPage(
                  session: state.extra as SessionView,
                ),
              ),
            ],
          ),

          // fadeGoRoute(
          //   path: Routes.videoExport.path,
          //   builder: (context, state) => const SizedBox(),
          // ),
          // fadeGoRoute(
          //   path: Routes.alerts.path,
          //   builder: (context, state) => const SizedBox(),
          // ),
          fadeGoRoute(
            path: Routes.settings.path,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}

GoRoute fadeGoRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  String? name,
  List<GoRoute>? routes,
}) {
  return GoRoute(
    path: path,
    name: name,
    routes: routes ?? [],
    pageBuilder: (context, state) => CustomTransitionPage<void>(
      key: state.pageKey,
      transitionDuration: const Duration(milliseconds: 150),
      child: builder(context, state),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeIn).animate(animation),
          child: child,
        );
      },
    ),
  );
}
