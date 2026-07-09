import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// Resolves a stable identifier for the current learner.
///
/// The app works fully offline and doesn't require account creation to
/// start studying, so this generates and persists a local anonymous id on
/// first launch. When Firebase Auth is configured (see AppConfig) and the
/// learner signs in — e.g. to sync XP to the global leaderboard — callers
/// should prefer the Firebase uid instead; this service is the fallback
/// that keeps local progress tracking working with zero setup.
class UserIdentityService {
  static const _prefsKey = 'local_user_id';

  Future<String> getOrCreateLocalUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getString(_prefsKey);
    if (existing != null) return existing;

    final generated = const Uuid().v4();
    await prefs.setString(_prefsKey, generated);
    return generated;
  }
}
