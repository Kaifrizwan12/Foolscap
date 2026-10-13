import 'package:flutter/material.dart';

/// "Foolscap Manuscript" palette — see docs/STITCH_UI_PROMPT.md section 1.3
/// for the full rationale. Widgets must consume these (or the ColorScheme
/// built from them), never hardcode a Color inline — see
/// docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 7.
///
/// Light-mode values below. Dark mode ("the night desk") swaps ink/paper
/// and brightens jesterRed/sealGold/sage/clay slightly for contrast — see
/// AppTheme._build and the token table in docs/STITCH_UI_PROMPT.md.
class ColorTokens {
  ColorTokens._();

  // Ink/Paper swap between light and dark — see AppTheme.
  static const Color inkLight = Color(0xFF1A1A1A);
  static const Color paperLight = Color(0xFFFBF8F1);
  static const Color inkDark = Color(0xFFF2EEE4);
  static const Color paperDark = Color(0xFF15130F);

  // The one loud color. Primary actions, capture/record affordances, the
  // brand mark. Keep it to roughly 5% of any given screen.
  static const Color jesterRedLight = Color(0xFFFF3B6B);
  static const Color jesterRedDark = Color(0xFFFF4D76);

  // Approvals, wax-seal stamps, "locked/final" states.
  static const Color sealGoldLight = Color(0xFFB8860B);
  static const Color sealGoldDark = Color(0xFFD4A62B);

  // Success / "ready" status / positive outlier scores.
  static const Color sageLight = Color(0xFF5B7A5E);
  static const Color sageDark = Color(0xFF7FA083);

  // Warnings, errors, linter flags. Deliberately NOT jesterRed — the one
  // bright brand color never gets diluted into every error toast.
  static const Color clayLight = Color(0xFFB5553A);
  static const Color clayDark = Color(0xFFD97158);

  // Secondary text, dividers, placeholders, disabled states.
  static const Color graphiteLight = Color(0xFF6B6559);
  static const Color graphiteDark = Color(0xFF8A8475);
}
