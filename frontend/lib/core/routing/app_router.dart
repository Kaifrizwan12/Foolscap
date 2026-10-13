import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/sign_in_page.dart';
import '../../features/library/presentation/library_page.dart';
import '../../features/pitch/presentation/pitch_list_page.dart';
import '../../features/workspaces/presentation/workspace_select_page.dart';
import '../widgets/app_shell.dart';
import 'route_paths.dart';

/// See docs/NAVIGATION.md for the full route table and docs/
/// TECHNICAL_DEEP_DIVE.md section 1.5 for why this shape was chosen.
///
/// TODO(phase-0): wire `refresh Listenable: authController` and the
/// signed-in/workspace-selected `redirect` guards once AuthController and
/// WorkspaceController are available via Provider at the GoRouter call site.
final GoRouter appRouter = GoRouter(
  initialLocation: RoutePaths.signIn,
  routes: [
    GoRoute(
      path: RoutePaths.signIn,
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: RoutePaths.workspaceSelect,
      builder: (context, state) => const WorkspaceSelectPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.library, builder: (_, __) => const LibraryPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/room/:scriptId',
            builder: (context, state) => Scaffold(
              body: Center(child: Text('Writing Room: ${state.pathParameters['scriptId']}')),
            ),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: RoutePaths.pitches, builder: (_, __) => const PitchListPage()),
        ]),
      ],
    ),
  ],
);
