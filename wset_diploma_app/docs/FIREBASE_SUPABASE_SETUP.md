# Enabling Supabase, Firebase, and the AI explanation backend

None of this is required to build or study with the app — it works fully
offline out of the box. This is for enabling cloud sync of the question
bank, the global leaderboard, and AI-generated answer explanations.

## 1. Supabase (question bank sync)

1. Create a project at [supabase.com](https://supabase.com).
2. Create a `questions` table matching the shape read by
   `lib/data/remote/question_row_mapper.dart`:

   ```sql
   create table questions (
     id text primary key,
     module text not null,
     topic_ids text[] not null default '{}',
     type text not null,
     difficulty int not null,
     prompt text not null,
     options text[] not null default '{}',
     correct_option_indexes int[] not null default '{}',
     model_short_answer text not null default '',
     explanation text not null,
     image_asset_paths text[] not null default '{}',
     "references" text[] not null default '{}',
     tags text[] not null default '{}',
     updated_at timestamptz not null default now()
   );

   -- Read-only for anonymous/public clients; write access should be
   -- restricted to your content-authoring pipeline/service role.
   alter table questions enable row level security;
   create policy "questions are publicly readable"
     on questions for select using (true);
   ```

3. Grab the project URL and anon/public key from Project Settings → API.
4. Build/run with:

   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=xxxx
   ```

Until these are supplied, `AppConfig.hasSupabaseConfig` is `false` and
`QuestionRepositoryImpl.syncFromRemote()` is a no-op — the app runs on
bundled seed content only.

## 2. Firebase (global leaderboard)

1. Create a project at the [Firebase console](https://console.firebase.google.com).
2. Enable Firestore (Native mode).
3. Add an Android app to the Firebase project (package name must match
   `android/app/build.gradle`'s `applicationId`).
4. Install the FlutterFire CLI and run it from the project root:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

   This overwrites `lib/firebase_options.dart` (currently a placeholder that
   deliberately disables Firebase — see the file's doc comment) with your
   project's real platform configuration.
5. Add Firestore security rules restricting writes appropriately, e.g.:

   ```
   match /leaderboard/{userId} {
     allow read: if true;
     allow write: if request.auth != null && request.auth.uid == userId;
   }
   ```

   (Requires wiring up Firebase Auth first — not included by default, since
   the app is designed to be usable without any account.)

## 3. AI explanation backend

The client never calls an LLM provider directly (that would require
embedding a secret key in the shipped APK). Instead, deploy a small backend
function — a Supabase Edge Function or Firebase Cloud Function both work —
that:

1. Accepts a POST body: `{ question, options, correctOptionIndexes,
   learnerSelectedOptionIndexes, curatedExplanation, followUpQuestion }`.
2. Calls your LLM provider of choice server-side (with the API key stored
   as a backend secret, not in the client).
3. Returns `{ "explanation": "..." }`.

Then point the app at it:

```bash
flutter run --dart-define=AI_EXPLANATION_ENDPOINT=https://xxxx.functions.supabase.co/explain
```

If the endpoint is unset, unreachable, or errors, `AiExplanationRemoteDataSource`
falls back to the question's own curated `explanation` field — the learner
never sees a blank/broken explanation.

## Combining all three at once

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxxx \
  --dart-define=AI_EXPLANATION_ENDPOINT=https://xxxx.functions.supabase.co/explain
```

(and run `flutterfire configure` once beforehand for Firebase.)

For release builds, pass the same `--dart-define` flags to
`flutter build appbundle` and consider loading them from a `--dart-define-from-file`
JSON kept out of version control.
