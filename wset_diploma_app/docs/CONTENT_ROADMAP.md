# Content roadmap: from 69 seed questions to 10,000+

The original brief calls for "more than 10,000 questions" and a full visual
library (grape/region/soil/map/aroma imagery). Building the *app* that can
hold and serve that content is a software engineering task; authoring and
vetting 10,000 professionally accurate WSET Diploma questions is a
**content-authoring task at the scale of a small publishing project** —
comparable in effort to the WSET's own study guides. This repo does the
former today and lays out exactly how the latter plugs in.

## What's bundled right now

| Module | Questions | Notes |
|---|---|---|
| D1 — Wine Production | 15 | Viticulture, vinification, tasting science |
| D2 — Wine Business | 12 | Trade, distribution, law, finance |
| D3 — Wines of the World | 15 | Sample across France/Italy/Spain/Germany/New World |
| D4 — Sparkling Wines | 10 | Traditional/tank/ancestral methods, regions |
| D5 — Fortified Wines | 10 | Sherry, Port, Madeira, VDN |
| D6 — Independent Research Assignment | 7 | Research methodology (D6 has no closed-book exam) |
| **Total** | **69** | Every question has a full explanation and topic tags |

Plus 14 flashcards, 11 grape profiles, 8 region profiles, and 8 achievement
definitions — all real, accurate content (not placeholders), just a small
fraction of full syllabus coverage.

Every question and profile follows one fixed schema (`lib/domain/entities/`)
tagged by module and `topicId` (e.g. `d3.france.burgundy`). That taxonomy —
not the row count — is the part that has to be right before scaling
content, and it's already in place.

## The actual path to 10,000+

1. **Author in bulk against the existing schema.** `Question` fields map
   1:1 onto a spreadsheet/CSV: `module, topic_ids, type, difficulty, prompt,
   options, correct_option_indexes, explanation, references, tags`. Subject
   matter experts (or a licensed content partner) fill this in; a script
   converts rows into the same `questions` table `SupabaseQuestionDataSource`
   already reads (`lib/data/remote/question_row_mapper.dart` documents the
   exact wire shape).
2. **Push through Supabase, not app updates.** Because the question bank
   lives in Postgres and syncs incrementally (`QuestionRepository.
   syncFromRemote`), reaching 10,000 questions is a content-pipeline/database
   operation — it does not require shipping a new app build to add
   questions.
3. **Difficulty and topic tagging drive the adaptive engine "for free".**
   `AdaptiveSelector` and the mock-exam generator already key off
   `difficulty` (1–5) and `topicId` — new content plugs directly into
   spaced repetition and weak-topic targeting with no code changes.
4. **Fact-check against primary sources.** Every seed question here cites
   its topic area; a production content pipeline should track sourcing
   against the current WSET Diploma Specification and Study Guides
   directly, ideally with a second qualified reviewer (e.g. WSET Educator,
   Certified Wine Educator) per batch — the same bar WSET itself applies.
5. **Reuse the module weighting already encoded in `generate_mock_exam_
   usecase.dart`** (`_examQuestionCounts`) so mock exams stay
   proportionate to the real exam paper shapes as the bank grows.

## Imagery (grapes, regions, soils, maps, aroma wheels)

`assets/images/{grapes,regions,soils,maps,aromas}/` exist as directories
(each with a placeholder `README.md`) and `GrapeProfile`/`RegionProfile`
already carry an `imageAssetPath` field wired into the UI
(`GrapeProfileDetailScreen`, `RegionProfileDetailScreen`). What's missing is
the actual artwork:

- **Maps**: commission or license region/appellation maps (WSET's own maps
  are copyrighted; do not bundle them without a license — commission
  original cartography instead).
- **Grape/soil photography**: license stock imagery or commission original
  photography; avoid scraping copyrighted educational material.
- **Aroma wheels**: the classic aroma wheel format (Noble/Davis-style) is
  copyrighted by its original authors — commission an original visual
  language for descriptor categories rather than reproducing an existing
  wheel.

## SAT simulator practice library

Today there is one bundled practice wine (`sat_simulator_screen.dart`). The
comparator (`SatNoteComparator`) already supports arbitrary model notes —
scaling this is "add more `SatNote` model answers," not new code.

## Global leaderboard and multi-user features

Firestore scales to thousands of concurrent readers on the free/Blaze tier
architecture used here; going from "wired, untested" to "battle-tested at
scale" mainly means load-testing the leaderboard read pattern and adding
Firestore security rules restricting writes to `request.auth.uid ==
resource.id` once Firebase Auth is turned on (currently `pushLocalScore`
assumes a trusted client, fine for early testing, not for public launch).
