import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Owns the breakpoint switch between bottom nav (phone) and side nav
/// (tablet) — Android/iOS only, no desktop target. Pages never check
/// MediaQuery for this themselves — see
/// docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 6 and docs/NAVIGATION.md.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    (icon: Icons.video_library_outlined, label: 'Library'),
    (icon: Icons.edit_note_outlined, label: 'Room'),
    (icon: Icons.send_outlined, label: 'Pitches'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;

    if (isWide) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (i) => navigationShell.goBranch(i),
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final d in _destinations)
                  NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label)),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i),
        destinations: [
          for (final d in _destinations)
            NavigationDestination(icon: Icon(d.icon), label: d.label),
        ],
      ),
    );
  }
}
