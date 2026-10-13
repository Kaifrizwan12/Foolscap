/// Semantic spacing tokens instead of random numbers everywhere, per
/// docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 7.
///
/// Radius values are intentionally small — docs/STITCH_UI_PROMPT.md section
/// 1.2: "Corners are mostly sharp or very slightly rounded (2-4px), never
/// pill-shaped buttons as the default." `radiusPill` exists only for the
/// one load-bearing exception: Rubber Stamp status chips.
class SpacingTokens {
  SpacingTokens._();

  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 2;
  static const double radiusMd = 4;
  static const double radiusLg = 8;
  static const double radiusPill = 999; // Rubber Stamp chips only
}
