# WSET Diploma Prep

An offline-first Flutter study companion for candidates preparing for the
**WSET Level 4 Diploma in Wines** (D1–D6): an adaptive quiz engine built on
spaced repetition, flashcards, full-length mock exams, a SAT (Systematic
Approach to Tasting) simulator, grape/region reference profiles, gamification,
and optional cloud sync via Supabase + Firebase.

> **Status: early-stage foundation, not a finished 10,000-question product.**
> This repo ships a working, tested Clean Architecture skeleton with a real
> (if intentionally small) seed content set — see
> [`docs/CONTENT_ROADMAP.md`](docs/CONTENT_ROADMAP.md) for exactly what's
> bundled today and the concrete path to the full-scale question bank,
> imagery, and infrastructure described in the original brief. Fabricating
> 10,000 exam-quality WSET questions on request would risk shipping
> inaccurate study material for a real professional certification — that
> content has to be authored and vetted, not generated wholesale.

## What's actually implemented

| Area | Status |
|---|---|
| Clean Architecture (domain / data / presentation) | ✅ Full skeleton, SOLID-oriented |
| Adaptive quiz (SRS due-ness + weak-topic + difficulty blending) | ✅ Working, unit-tested |
| Spaced repetition (SM-2) for quiz questions *and* flashcards | ✅ Working, unit-tested |
| Flashcards | ✅ Working |
| Full-length mock exams (exam-shaped question counts per module) | ✅ Working |
| SAT tasting simulator (self-comparison against a model note) | ✅ Working (1 practice wine bundled) |
| Question bank, D1–D6 | ✅ 69 seed questions across all 6 modules — see roadmap |
| Grape / region profiles | ✅ 11 grapes, 8 regions — see roadmap |
| Gamification: XP, levels, streaks, achievements | ✅ Working |
| Statistics dashboard | ✅ Working (charts via `fl_chart`) |
| Study planner (countdown to exam date) | ✅ Working |
| Offline mode | ✅ SQLite-backed local store is the source of truth |
| Cloud sync (Supabase question bank) | ✅ Wired, no-op until you supply credentials |
| Global leaderboard (Firebase) | ✅ Wired, no-op until you supply credentials |
| AI explanation service | ✅ Wired to call *your* backend endpoint; falls back to curated explanations |
| Search | ✅ Across questions, grapes, regions |
| Favorites | ✅ Working |
| Images (grapes/regions/soils/maps/aroma wheels) | ❌ Not bundled — placeholders only, see roadmap |
| Tests | ✅ 26 automated tests (`flutter test`), `flutter analyze` clean |

## Getting started

```bash
flutter pub get
flutter test
flutter run
```

The app works fully offline out of the box: on first launch it seeds its
local SQLite database from the bundled question/flashcard content and is
immediately usable with no configuration, no account, and no network.

### Enabling cloud sync, the leaderboard, and AI explanations (optional)

These are all optional and the app is designed to degrade gracefully
without them. See [`docs/FIREBASE_SUPABASE_SETUP.md`](docs/FIREBASE_SUPABASE_SETUP.md)
for the full walkthrough. Short version:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=xxxx \
  --dart-define=AI_EXPLANATION_ENDPOINT=https://xxxx.functions.supabase.co/explain
```

and run `flutterfire configure` to generate a real `lib/firebase_options.dart`
for the leaderboard.

## Architecture

See [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the layer-by-layer
breakdown (domain/data/presentation), the offline-first sync model, and why
specific technology choices were made (Supabase for the question bank vs.
Firebase for the leaderboard, SQLite as the offline source of truth, SM-2 for
spaced repetition, etc).

## Content roadmap

See [`docs/CONTENT_ROADMAP.md`](docs/CONTENT_ROADMAP.md) for what it actually
takes to go from today's 69 seed questions to a 10,000+ question, fully
illustrated question bank — and how the schema/pipeline already in this repo
supports that growth without further architectural change.

## Tech stack

Flutter · Riverpod · SQLite (`sqflite`, offline-first local store) ·
Supabase (Postgres-backed question bank + sync) · Firebase (Firestore
leaderboard, optional Auth) · `fl_chart` for statistics.
