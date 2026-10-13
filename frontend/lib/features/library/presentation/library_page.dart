import 'package:flutter/material.dart';

/// Placeholder shell for the Library tab. Real implementation (folders,
/// tags, search, X-Ray status) lands in Phase 1 — see docs/FEATURE_PLAN.md.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: const Center(child: Text('Phase 1: references, folders, X-Ray')),
    );
  }
}
