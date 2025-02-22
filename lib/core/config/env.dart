class Env {
  static String get apiUrl => const String.fromEnvironment('API_URL',
      defaultValue: 'https://default.api.com');
  static String get authToken =>
      const String.fromEnvironment('AUTH_TOKEN', defaultValue: 'default_token');
}
