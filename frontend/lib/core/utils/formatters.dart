/// Reusable formatting helpers. Keep parsing/formatting out of UI code per
/// docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 18.
class Formatters {
  Formatters._();

  static String duration(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  static String wordsPerMinute(double wpm) => '${wpm.round()} wpm';
}
