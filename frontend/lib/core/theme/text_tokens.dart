import 'package:flutter/material.dart';

/// Three families, each with one job — see docs/STITCH_UI_PROMPT.md
/// section 1.4. Swap the fontFamily values once real font files are added
/// to assets/fonts and declared in pubspec.yaml; these generic fallbacks
/// keep the app buildable in the meantime but are NOT the final look.
class TextTokens {
  TextTokens._();

  /// Confident serif. Page titles, the wordmark, Hook Bench hook text.
  /// Target feel: Fraunces / Source Serif. Falls back to the platform serif
  /// until a real font asset is added.
  static const String displayFamily = 'serif';

  /// Clean humanist sans. Everything else — buttons, labels, body, forms.
  /// Target feel: Inter / General Sans.
  static const String bodyFamily = 'Roboto';

  /// Typewriter monospace. ONLY for: the live speaking-pace timer, X-Ray
  /// stat numbers, word counts, take numbers, the pitch revision counter.
  /// Target feel: JetBrains Mono / Space Mono.
  static const String numericFamily = 'monospace';

  static const TextStyle display = TextStyle(fontFamily: displayFamily, fontSize: 32, fontWeight: FontWeight.w600);
  static const TextStyle heading = TextStyle(fontFamily: displayFamily, fontSize: 24, fontWeight: FontWeight.w600);
  static const TextStyle subtitle = TextStyle(fontFamily: displayFamily, fontSize: 20, fontWeight: FontWeight.w500);
  static const TextStyle body = TextStyle(fontFamily: bodyFamily, fontSize: 16, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle secondary = TextStyle(fontFamily: bodyFamily, fontSize: 14, fontWeight: FontWeight.w400, height: 1.4);
  static const TextStyle caption = TextStyle(fontFamily: bodyFamily, fontSize: 13, fontWeight: FontWeight.w400);
  static const TextStyle label = TextStyle(fontFamily: bodyFamily, fontSize: 14, fontWeight: FontWeight.w500);

  /// Readout style — timers, X-Ray stats, word counts, revision counters.
  /// Never used for prose. See docs/STITCH_UI_PROMPT.md section 1.4.
  static const TextStyle numeric = TextStyle(fontFamily: numericFamily, fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle numericLarge = TextStyle(fontFamily: numericFamily, fontSize: 24, fontWeight: FontWeight.w600);
}
