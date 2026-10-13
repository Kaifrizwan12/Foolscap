import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/env.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage_service.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/domain/auth_controller.dart';
import '../features/workspaces/data/workspaces_repository.dart';
import '../features/workspaces/domain/workspace_controller.dart';
import 'app.dart';

/// Wires every app-lifetime dependency once, at startup, and hands it down
/// via [MultiProvider]. Screen-scoped controllers are NOT wired here — see
/// docs/STATE_MANAGEMENT.md for the scoping rule.
Future<Widget> bootstrap() async {
  // TODO(phase-0): await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Deferred until `flutterfire configure` has been run per docs/ENVIRONMENTS.md.

  final apiClient = ApiClient(baseUrl: Env.apiBaseUrl);
  final secureStorage = SecureStorageService();

  final authRepository = AuthRepository();
  final workspacesRepository = WorkspacesRepository(apiClient: apiClient);

  return MultiProvider(
    providers: [
      Provider<ApiClient>.value(value: apiClient),
      Provider<SecureStorageService>.value(value: secureStorage),
      ChangeNotifierProvider(create: (_) => AuthController(authRepository)),
      ChangeNotifierProvider(
        create: (_) => WorkspaceController(workspacesRepository),
      ),
    ],
    child: const FoolscapApp(),
  );
}
