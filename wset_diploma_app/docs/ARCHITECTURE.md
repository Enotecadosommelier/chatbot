# Architecture

This app follows Clean Architecture with three layers, each only depending
inward (presentation → domain ← data), so the domain layer has zero
knowledge of Flutter, SQLite, Supabase, or Firebase.

```
lib/
  core/         Cross-cutting, framework-light building blocks
  domain/       Entities, repository interfaces, use cases — pure Dart
  data/         Repository implementations, local DB, remote data sources, seed content
  presentation/ Riverpod controllers/providers + Flutter screens/widgets
```

## Domain layer (`lib/domain`)

- **Entities** (`entities/`): plain Dart classes — `Question`, `Flashcard`,
  `SrsState`, `UserProgress`, `Achievement`, `StudyPlan`, `GrapeProfile`,
  `RegionProfile`, `QuizSession`, `LeaderboardEntry`. No Flutter, no
  persistence-framework annotations.
- **Repository interfaces** (`repositories/`): abstract contracts
  (`QuestionRepository`, `ProgressRepository`, etc.) that the data layer
  implements. Use cases and presentation code depend on these interfaces,
  never on `data/` directly — that's what makes the local SQLite store
  swappable for a different persistence engine without touching business
  logic, and what makes the use cases unit-testable with mocks (see
  `test/domain/usecases/submit_quiz_answer_usecase_test.dart`).
- **Use cases** (`usecases/`): one class per user-facing operation
  (`GetAdaptiveQuizSessionUseCase`, `SubmitQuizAnswerUseCase`,
  `GenerateMockExamUseCase`, `CompareSatNoteUseCase`, ...). Each does exactly
  one thing and is a natural seam for unit tests.

## Core layer (`lib/core`)

Algorithmic and infrastructure code that domain/data both lean on, kept
dependency-free where possible so it's testable with plain `dart test`
(no Flutter SDK needed):

- `spaced_repetition/sm2_scheduler.dart` — the SM-2 spaced-repetition
  algorithm. Same review queue backs both quiz questions and flashcards.
- `adaptive/adaptive_selector.dart` — blends SRS due-ness, topic weakness,
  and difficulty-vs-mastery matching to rank the next quiz questions.
- `sat/sat_note_comparator.dart` — field-by-field comparison of a learner's
  SAT tasting note against a model note. Deliberately *not* a pass/fail
  grader: wine assessment is subjective, so this is framed as a study aid,
  not an authority.
- `services/ai_explanation_service.dart` — an interface only. The concrete
  implementation calls a backend endpoint you deploy yourself (Supabase Edge
  Function / Firebase Cloud Function); no LLM API key is ever embedded in
  the client. See `docs/AI_EXPLANATION_BACKEND.md`.

## Data layer (`lib/data`)

- **`local/`** — `AppDatabase` (sqflite) is the single offline source of
  truth. DAOs (`QuestionDao`, `ProgressDao`, ...) are the only code that
  talks SQL.
- **`remote/`** — `SupabaseQuestionDataSource` pulls the (much larger,
  continuously growing) canonical question bank from Postgres;
  `FirebaseLeaderboardDataSource` reads/writes the global leaderboard in
  Firestore; `AiExplanationRemoteDataSource` calls your explanation backend
  and falls back to the question's own curated explanation on any failure.
- **`repositories_impl/`** — implements the domain repository interfaces by
  combining local DAOs with (optional) remote data sources. Every remote
  data source is nullable and every repository method still works with it
  `null` — that's what makes the whole app offline-first rather than
  offline-broken.
- **`seed/`** — bundled starter content (`seedQuestionsD1`...`D6`,
  `seedFlashcards`, `kSeedGrapeProfiles`, `kSeedRegionProfiles`,
  `kSeedAchievements`) and `SeedLoader`, which populates the local DB once,
  on first launch, if it's empty.

### Why Supabase *and* Firebase, not just one?

- **Supabase (Postgres)** is the system of record for the question bank:
  relational, easy to bulk-author/import into (CSV/SQL), and a natural fit
  for a dataset that's large but changes in big, infrequent batches (new
  content drops), pulled incrementally via `syncFromRemote()`.
- **Firebase (Firestore)** backs the global leaderboard: a small, frequently
  updated dataset where Firestore's mobile SDK, offline cache, and
  aggregation queries (`count()`) are a good fit, and where Firebase Auth is
  the natural pairing if/when account-based sync is added.

This is a deliberate two-backend design, not indecision — each is used for
what it's good at, and both are entirely optional at build time.

## Offline-first sync model

1. On first launch, `SeedLoader.seedIfEmpty()` populates SQLite from the
   bundled Dart seed data (instant, no network).
2. If online, `QuestionRepository.syncFromRemote()` pulls anything newer
   from Supabase and upserts it locally (best-effort; failures never block
   startup — see `appBootstrapProvider` in
   `lib/presentation/state/providers.dart`).
3. Every screen reads from the local repository. The app never blocks on
   network for the core study loop (quiz, flashcards, mock exams, SAT
   simulator, stats, planner).
4. Only the global leaderboard genuinely requires connectivity; its screen
   says so explicitly rather than silently showing stale/fake data.

## State management

Riverpod, hand-written (no `riverpod_generator` codegen) so the whole
project builds with plain `flutter pub get` — no `build_runner` step.
`providers.dart` is the composition root/DI graph; feature-specific
controllers (`QuizController`, `FlashcardController`, ...) are
`StateNotifier`s that call into use cases, never into repositories or DAOs
directly.

## Testing

- Pure-Dart core algorithms (`sm2_scheduler`, `adaptive_selector`,
  `sat_note_comparator`) have full unit test coverage and are designed to be
  testable without the Flutter SDK at all.
- Domain use cases are tested with `mocktail` against the repository
  interfaces (see `test/domain/usecases/`).
- `flutter analyze` is clean and `flutter test` passes end-to-end
  (26 tests at time of writing).
