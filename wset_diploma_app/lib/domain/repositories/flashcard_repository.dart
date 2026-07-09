import '../../core/constants/wset_modules.dart';
import '../entities/flashcard.dart';

abstract class FlashcardRepository {
  Future<List<Flashcard>> getByModule(WsetModule module);
  Future<List<Flashcard>> getByTopic(String topicId);
  Future<Flashcard?> getById(String id);
  Future<int> syncFromRemote();
}
