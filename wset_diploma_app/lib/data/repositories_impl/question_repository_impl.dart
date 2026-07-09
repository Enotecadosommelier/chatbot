import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';
import '../../domain/repositories/question_repository.dart';
import '../local/daos/question_dao.dart';
import '../remote/supabase_question_datasource.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionDao dao;
  final SupabaseQuestionDataSource? remoteDataSource;
  DateTime? _lastSyncedAt;

  QuestionRepositoryImpl({required this.dao, this.remoteDataSource});

  @override
  Future<List<Question>> getByModule(WsetModule module) =>
      dao.getByModule(module);

  @override
  Future<List<Question>> getByTopic(String topicId) => dao.getByTopic(topicId);

  @override
  Future<List<Question>> getByIds(List<String> ids) => dao.getByIds(ids);

  @override
  Future<Question?> getById(String id) => dao.getById(id);

  @override
  Future<List<Question>> search(String query) => dao.search(query);

  @override
  Future<int> countAll() => dao.count();

  @override
  Future<int> syncFromRemote() async {
    if (remoteDataSource == null) return 0;
    final updated = await remoteDataSource!.fetchUpdatedSince(_lastSyncedAt);
    if (updated.isEmpty) {
      _lastSyncedAt = DateTime.now();
      return 0;
    }
    await dao.upsertAll(updated);
    _lastSyncedAt = DateTime.now();
    return updated.length;
  }
}
