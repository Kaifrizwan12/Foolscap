import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'spacing_tokens.dart';
import 'text_tokens.dart';

/// Lives near app initialization; widgets consume theme tokens, never
/// define design constants inline. See docs/FLUTTER_FULL_STACK_PLAYBOOK.md
/// section 7 and docs/STITCH_UI_PROMPT.md for the full "Foolscap
/// Manuscript" design direction this theme approximates — signature
/// components (Dog-Ear Fold, Wax Seal, Redline Annotation, Rubber Stamp
/// chips, etc.) are built from these tokens but implemented as custom
/// widgets, not ThemeData, once the Stitch output lands.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final ink = isDark ? ColorTokens.inkDark : ColorTokens.inkLight;
    final paper = isDark ? ColorTokens.paperDark : ColorTokens.paperLight;
    final jesterRed = isDark ? ColorTokens.jesterRedDark : ColorTokens.jesterRedLight;
    final clay = isDark ? ColorTokens.clayDark : ColorTokens.clayLight;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: jesterRed,
      brightness: brightness,
      surface: paper,
      onSurface: ink,
      error: clay,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        headlineMedium: TextTokens.display.copyWith(color: ink),
        titleLarge: TextTokens.heading.copyWith(color: ink),
        titleMedium: TextTokens.subtitle.copyWith(color: ink),
        bodyLarge: TextTokens.body.copyWith(color: ink),
        bodyMedium: TextTokens.secondary.copyWith(color: ink),
        bodySmall: TextTokens.caption.copyWith(color: ink),
        labelLarge: TextTokens.label.copyWith(color: ink),
      ),
      appBarTheme: AppBarTheme(backgroundColor: colorScheme.surface, elevation: 0),
      // No pill-shaped buttons by default, no elevation — see
      // docs/STITCH_UI_PROMPT.md section 1.2. Signature components
      // (Rubber Stamp chips, Wax Seal) are custom widgets, not themed here.
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpacingTokens.radiusMd),
          side: BorderSide(color: ink.withValues(alpha: 0.12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(SpacingTokens.radiusSm)),
        ),
      ),
    );
  }
}
