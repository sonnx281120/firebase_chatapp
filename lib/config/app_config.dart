class EnvConfig {
  static const String cloudName =
      String.fromEnvironment('CLOUDINARY_CLOUD_NAME', defaultValue: '');
  static const String cloudinaryApiKey =
      String.fromEnvironment('CLOUDINARY_API_KEY', defaultValue: '');
  static const String cloudinaryApiSecret =
      String.fromEnvironment('CLOUDINARY_API_SECRET', defaultValue: '');
}
