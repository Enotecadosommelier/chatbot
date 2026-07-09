import '../local/daos/flashcard_dao.dart';
import '../local/daos/question_dao.dart';
import 'seed_flashcards.dart';
import 'seed_questions_d1.dart';
import 'seed_questions_d2.dart';
import 'seed_questions_d3.dart';
import 'seed_questions_d4.dart';
import 'seed_questions_d5.dart';
import 'seed_questions_d6.dart';

/// Populates the local offline database with bundled seed content on
/// first launch. Idempotent — safe to call on every app start, since it
/// only writes when the local tables are empty. Once bundled seed
/// content is present, [QuestionRepository.syncFromRemote] can layer the
/// full Supabase-hosted question bank on top as connectivity allows.
class SeedLoader {
  final QuestionDao questionDao;
  final FlashcardDao flashcardDao;

  SeedLoader({required this.questionDao, required this.flashcardDao});

  Future<void> seedIfEmpty() async {
    if (await questionDao.count() == 0) {
      await questionDao.upsertAll([
        ...seedQuestionsD1,
        ...seedQuestionsD2,
        ...seedQuestionsD3,
        ...seedQuestionsD4,
        ...seedQuestionsD5,
        ...seedQuestionsD6,
      ]);
    }

    if (await flashcardDao.count() == 0) {
      await flashcardDao.upsertAll(seedFlashcards);
    }
  }
}
