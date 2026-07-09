import 'package:firebase_core/firebase_core.dart';

/// Placeholder Firebase configuration.
///
/// A real deployment replaces this file by running:
///   flutterfire configure
/// which generates platform-specific `FirebaseOptions` (Android/iOS/web)
/// from your actual Firebase project. Until then, [isConfigured] is false
/// and main() skips Firebase.initializeApp() entirely — the whole app,
/// including the quiz, flashcards, and mock exams, works fully offline
/// without it. Only the global leaderboard needs Firebase.
///
/// See docs/FIREBASE_SUPABASE_SETUP.md for the full setup walkthrough.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static bool get isConfigured => false;

  static FirebaseOptions get currentPlatform {
    throw UnsupportedError(
      'DefaultFirebaseOptions.currentPlatform was called but this project has '
      'not been configured with `flutterfire configure` yet. See '
      'docs/FIREBASE_SUPABASE_SETUP.md.',
    );
  }
}
