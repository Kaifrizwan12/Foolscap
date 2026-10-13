import 'package:flutter/material.dart';

/// Shown for any network-driven screen while its controller is loading.
/// See docs/FLUTTER_FULL_STACK_PLAYBOOK.md sections 4, 15, 21 — every
/// network-driven screen must have this state.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.label});
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          if (label != null) ...[
            const SizedBox(height: 12),
            Text(label!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
