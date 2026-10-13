/// Centralized route path constants. No widget hardcodes a path string —
/// see docs/NAVIGATION.md and docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 5.
class RoutePaths {
  RoutePaths._();

  static const String signIn = '/sign-in';
  static const String workspaceSelect = '/workspaces/select';
  static const String library = '/library';
  static String libraryDetail(String referenceId) => '/library/$referenceId';
  static String room(String scriptId) => '/room/$scriptId';
  static const String pitches = '/pitches';
  static String pitchDetail(String pitchId) => '/pitches/$pitchId';
  // No pitchPublic route: Foolscap is Android/iOS only. The public pitch
  // link is a server-rendered HTML page served by the backend, not a
  // Flutter screen — see docs/ARCHITECTURE.md section 6.
  static String setMode(String scriptId) => '/set/$scriptId';
  static const String settings = '/settings';
}
