import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized access to environment configuration.
///
/// Resolution order per key:
///   1. Value from the loaded `.env` file (dev mode, via flutter_dotenv).
///   2. Value injected via `--dart-define` (release mode).
///
/// In dev, `main.dart` calls `dotenv.load()` before any access. In release,
/// the `.env` file is absent; values come from compile-time defines set with
/// `flutter build --dart-define=KEY=value`.
///
/// `String.fromEnvironment` only accepts a compile-time string literal, so each
/// known key is exposed as a concrete getter rather than read via a dynamic
/// key argument.
class Env {
  Env._();

  /// Supabase project URL.
  static String get supabaseUrl =>
      dotenv.maybeGet('SUPABASE_URL')?.takeIf((v) => v.isNotEmpty) ??
      const String.fromEnvironment('SUPABASE_URL');

  /// Supabase anon (publishable) key.
  static String get supabaseAnonKey =>
      dotenv.maybeGet('SUPABASE_ANON_KEY')?.takeIf((v) => v.isNotEmpty) ??
      const String.fromEnvironment('SUPABASE_ANON_KEY');

  /// PostHog API key (optional; absent until analytics wiring lands).
  static String? get posthogApiKey =>
      dotenv.maybeGet('POSTHOG_API_KEY')?.takeIf((v) => v.isNotEmpty) ??
      const String.fromEnvironment('POSTHOG_API_KEY')
          .takeIf((v) => v.isNotEmpty);

  /// Sentry DSN (optional).
  static String? get sentryDsn =>
      dotenv.maybeGet('SENTRY_DSN')?.takeIf((v) => v.isNotEmpty) ??
      const String.fromEnvironment('SENTRY_DSN').takeIf((v) => v.isNotEmpty);
}

/// Extension that adds a Kotlin/JS-style `takeIf` to [String] for terse
/// empty-checks when resolving env values.
extension _StringTakeIf on String {
  String? takeIf(bool Function(String) test) => test(this) ? this : null;
}
