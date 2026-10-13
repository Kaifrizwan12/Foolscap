/// JSON-safe, immutable. Tolerant of missing optional fields, not silent
/// about broken contracts — see docs/FLUTTER_FULL_STACK_PLAYBOOK.md section 10.
class WorkspaceModel {
  const WorkspaceModel({
    required this.id,
    required this.name,
    required this.ownerUid,
    required this.memberUids,
  });

  final String id;
  final String name;
  final String ownerUid;
  final List<String> memberUids;

  factory WorkspaceModel.fromJson(String id, Map<String, dynamic> json) {
    return WorkspaceModel(
      id: id,
      name: json['name'] as String? ?? 'Untitled workspace',
      ownerUid: json['ownerUid'] as String? ?? '',
      memberUids: (json['memberUids'] as List?)?.cast<String>() ?? const [],
    );
  }
}
