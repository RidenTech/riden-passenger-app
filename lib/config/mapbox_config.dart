class MapboxConfig {
  // Load token from environment variable or secure storage
  // NEVER hardcode your actual token here
  static String get accessToken {
    // For development, you can use a placeholder
    // In production, load from secure storage or environment
    const String token = String.fromEnvironment(
      'MAPBOX_ACCESS_TOKEN',
      defaultValue: '',
    );

    // TODO: Implement secure token loading
    // For now, return empty string - actual token should be set via environment
    return token;
  }

  // Alternative: Load from .env file using flutter_dotenv
  // static String get accessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
}