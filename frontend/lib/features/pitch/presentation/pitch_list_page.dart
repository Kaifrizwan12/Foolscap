import 'package:flutter/material.dart';

/// Placeholder shell for the Pitches tab. Real implementation (shareable
/// links, comments, approvals) lands in Phase 3 — see docs/FEATURE_PLAN.md.
class PitchListPage extends StatelessWidget {
  const PitchListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pitches')),
      body: const Center(child: Text('Phase 3: shareable links, comments, approvals')),
    );
  }
}
