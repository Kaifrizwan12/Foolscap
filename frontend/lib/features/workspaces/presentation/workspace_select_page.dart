import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/routing/route_paths.dart';
import '../domain/workspace_controller.dart';

/// Shown when the signed-in user has no workspace selected. See
/// docs/FEATURE_PLAN.md Phase 0.2, docs/NAVIGATION.md guards.
class WorkspaceSelectPage extends StatelessWidget {
  const WorkspaceSelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WorkspaceController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Choose a workspace')),
      body: Center(
        child: FilledButton(
          onPressed: controller.isLoading
              ? null
              : () async {
                  await context.read<WorkspaceController>().createWorkspace('My workspace');
                  if (context.mounted) context.go(RoutePaths.library);
                },
          child: const Text('Create a workspace'),
        ),
      ),
    );
  }
}
