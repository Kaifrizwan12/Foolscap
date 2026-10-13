/// Pure, reusable input validators for forms. See
/// docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 18 — formatting/parsing
/// belongs in helpers, not in UI code.
class Validators {
  Validators._();

  static String? requiredField(String? value, {String label = 'This field'}) {
    if (value == null || value.trim().isEmpty) return '$label is required.';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required.';
    final pattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!pattern.hasMatch(value.trim())) return 'Enter a valid email.';
    return null;
  }
}
