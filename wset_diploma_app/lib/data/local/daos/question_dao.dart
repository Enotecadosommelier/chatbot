import 'package:sqflite/sqflite.dart';

import '../../../core/constants/wset_modules.dart';
import '../../../domain/entities/question.dart';
import '../app_database.dart';

/// Maps [Question] to/from the `questions` table.
///
/// `references` is a SQL keyword, so the column is named `references_`; this
/// DAO is the single place that translates between the entity's map shape
/// (from [Question.toMap]/[Question.fromMap]) and the DB column name.
class QuestionDao {
  Future<Database> get _db => AppDatabase.instance.database;

  Map<String, Object?> _toRow(Question q) {
    final map = q.toMap();
    final references = map.remove('references');
    map['references_'] = references;
    return map;
  }

  Question _fromRow(Map<String, Object?> row) {
    final map = Map<String, Object?>.from(row);
    final references = map.remove('references_');
    map['references'] = references;
    return Question.fromMap(map);
  }

  Future<void> upsertAll(List<Question> questions) async {
    final db = await _db;
    final batch = db.batch();
    for (final q in questions) {
      batch.insert(
        'questions',
        _toRow(q),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int> count() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM questions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Question>> getByModule(WsetModule module) async {
    final db = await _db;
    final rows = await db.query(
      'questions',
      where: 'module = ?',
      whereArgs: [module.name],
    );
    return rows.map(_fromRow).toList();
  }

  Future<List<Question>> getByTopic(String topicId) async {
    final db = await _db;
    final rows = await db.query(
      'questions',
      where: 'topicIds LIKE ?',
      whereArgs: ['%$topicId%'],
    );
    return rows
        .map(_fromRow)
        .where((q) => q.topicIds.contains(topicId))
        .toList();
  }

  Future<List<Question>> getByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final db = await _db;
    final placeholders = List.filled(ids.length, '?').join(',');
    final rows = await db.query(
      'questions',
      where: 'id IN ($placeholders)',
      whereArgs: ids,
    );
    return rows.map(_fromRow).toList();
  }

  Future<Question?> getById(String id) async {
    final db = await _db;
    final rows = await db.query('questions', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }

  Future<List<Question>> search(String query) async {
    final db = await _db;
    final like = '%$query%';
    final rows = await db.query(
      'questions',
      where: 'prompt LIKE ? OR tags LIKE ? OR explanation LIKE ?',
      whereArgs: [like, like, like],
      limit: 50,
    );
    return rows.map(_fromRow).toList();
  }
}
