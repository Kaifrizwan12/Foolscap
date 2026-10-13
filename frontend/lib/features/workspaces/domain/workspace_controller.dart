import 'package:flutter/foundation.dart';

import '../../../core/errors/app_exception.dart';
import '../data/workspace_model.dart';
import '../data/workspaces_repository.dart';

/// App-lifetime controller — holds which workspace is currently active.
/// See docs/STATE_MANAGEMENT.md.
class WorkspaceController extends ChangeNotifier {
  WorkspaceController(this._repository);
  final WorkspacesRepository _repository;

  WorkspaceModel? _current;
  bool _isLoading = false;
  AppException? _error;

  WorkspaceModel? get current => _current;
  String? get currentWorkspaceId => _current?.id;
  bool get isLoading => _isLoading;
  AppException? get error => _error;

  Future<void> createWorkspace(String name) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _current = await _repository.createWorkspace(name);
    } catch (e) {
      _error = AppException.from(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearOnLogout() {
    _current = null;
    notifyListeners();
  }
}
