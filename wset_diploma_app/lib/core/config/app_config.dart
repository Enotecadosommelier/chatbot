/// Central place for the environment values every backend integration
/// needs. All of these are injected at build time via `--dart-define` (see
/// docs/FIREBASE_SUPABASE_SETUP.md) so no secret ever gets committed to the
/// repo or baked into source.
///
/// Example release build:
/// ```
/// flutter build appbundle \
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=xxxx \
///   --dart-define=AI_EXPLANATION_ENDPOINT=https://xxxx.functions.supabase.co/explain
/// ```
class AppConfig {
  AppConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const aiExplanationEndpoint =
      String.fromEnvironment('AI_EXPLANATION_ENDPOINT');

  static bool get hasSupabaseConfig =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  static bool get hasAiExplanationConfig => aiExplanationEndpoint.isNotEmpty;
}
