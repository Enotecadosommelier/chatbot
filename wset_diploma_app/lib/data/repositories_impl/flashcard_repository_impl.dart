import '../../core/constants/wset_modules.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../local/daos/flashcard_dao.dart';

class FlashcardRepositoryImpl implements FlashcardRepository {
  final FlashcardDao dao;

  FlashcardRepositoryImpl({required this.dao});

  @override
  Future<List<Flashcard>> getByModule(WsetModule module) =>
      dao.getByModule(module);

  @override
  Future<List<Flashcard>> getByTopic(String topicId) => dao.getByTopic(topicId);

  @override
  Future<Flashcard?> getById(String id) => dao.getById(id);

  @override
  Future<int> syncFromRemote() async {
    // Flashcards currently ship bundled with the app (see data/seed) and
    // don't yet have a dedicated Supabase table. Wiring one up follows the
    // exact same pattern as SupabaseQuestionDataSource.
    return 0;
  }
}
