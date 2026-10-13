/// Build-time environment config, selected via `--dart-define=ENVIRONMENT=dev|staging|prod`.
/// See docs/ENVIRONMENTS.md.
class Env {
  Env._();

  static const String name = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'dev',
  );

  static const Map<String, String> _apiBaseUrls = {
    'dev': 'https://us-central1-foolscap-dev.cloudfunctions.net/api/v1',
    'staging':
        'https://us-central1-foolscap-staging.cloudfunctions.net/api/v1',
    'prod': 'https://us-central1-foolscap-prod.cloudfunctions.net/api/v1',
  };

  static String get apiBaseUrl => _apiBaseUrls[name] ?? _apiBaseUrls['dev']!;
}
