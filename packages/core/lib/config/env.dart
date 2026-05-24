/// Compile-time env vars. Override via --dart-define at build time.
///   flutter run --dart-define=STRIPE_PUBLISHABLE_KEY=pk_test_xxx
class Env {
  static const String stripePublishableKey =
      String.fromEnvironment('STRIPE_PUBLISHABLE_KEY', defaultValue: '');
  static const String algoliaAppId =
      String.fromEnvironment('ALGOLIA_APP_ID', defaultValue: '');
  static const String algoliaSearchKey =
      String.fromEnvironment('ALGOLIA_SEARCH_KEY', defaultValue: '');
  static const bool isProd =
      bool.fromEnvironment('PROD', defaultValue: false);
}
