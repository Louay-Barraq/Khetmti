/// Compile-time configuration injected with
/// `--dart-define-from-file=config/env.json` (see config/env.example.json).
class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static void ensureConfigured() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing Supabase config. Run with '
        '--dart-define-from-file=config/env.json',
      );
    }
  }
}
