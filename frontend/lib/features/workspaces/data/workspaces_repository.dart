import '../../../core/network/api_client.dart';
import 'workspace_model.dart';

/// Workspace creation/invites go through the backend (role mutation must be
/// server-checked — see docs/SECURITY_PRACTICES.md); workspace reads for the
/// current user will move to a direct Firestore stream once Phase 0 ships
/// (see docs/FEATURE_PLAN.md Phase 0.2).
class WorkspacesRepository {
  WorkspacesRepository({required this.apiClient});
  final ApiClient apiClient;

  Future<WorkspaceModel> createWorkspace(String name) async {
    final data = await apiClient.post('/workspaces', data: {'name': name});
    return WorkspaceModel.fromJson(data['id'] as String, data);
  }

  Future<WorkspaceModel> acceptInvite(String token) async {
    final data = await apiClient.post('/workspaces/invites/$token/accept');
    return WorkspaceModel.fromJson(data['id'] as String, data);
  }
}
