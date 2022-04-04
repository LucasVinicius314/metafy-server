class Env {
  static String? get apiAuthorityDev =>
      const String.fromEnvironment('API_AUTHORITY_DEV');

  static String? get apiAuthorityProd =>
      const String.fromEnvironment('API_AUTHORITY_PROD');

  static String? get cdnUrl => const String.fromEnvironment('CDN_URL');
}
