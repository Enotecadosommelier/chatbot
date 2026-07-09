import '../../core/constants/wset_modules.dart';
import '../entities/question.dart';

abstract class QuestionRepository {
  Future<List<Question>> getByModule(WsetModule module);
  Future<List<Question>> getByTopic(String topicId);
  Future<List<Question>> getByIds(List<String> ids);
  Future<Question?> getById(String id);
  Future<List<Question>> search(String query);
  Future<int> countAll();

  /// Pulls down any new/updated questions from the remote question bank
  /// (Supabase) and upserts them into the local offline store. Safe to call
  /// opportunistically whenever connectivity is available.
  Future<int> syncFromRemote();
}
