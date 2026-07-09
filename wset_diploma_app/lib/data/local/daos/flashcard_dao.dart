import 'package:sqflite/sqflite.dart';

import '../../../core/constants/wset_modules.dart';
import '../../../domain/entities/flashcard.dart';
import '../app_database.dart';

class FlashcardDao {
  Future<Database> get _db => AppDatabase.instance.database;

  Map<String, Object?> _toRow(Flashcard f) => {
        'id': f.id,
        'module': f.module.name,
        'topicIds': f.topicIds.join('|'),
        'front': f.front,
        'back': f.back,
        'imageAssetPath': f.imageAssetPath,
      };

  Flashcard _fromRow(Map<String, Object?> row) => Flashcard(
        id: row['id']! as String,
        module: WsetModule.values.byName(row['module']! as String),
        topicIds: (row['topicIds']! as String)
            .split('|')
            .where((e) => e.isNotEmpty)
            .toList(),
        front: row['front']! as String,
        back: row['back']! as String,
        imageAssetPath: row['imageAssetPath'] as String?,
      );

  Future<void> upsertAll(List<Flashcard> cards) async {
    final db = await _db;
    final batch = db.batch();
    for (final c in cards) {
      batch.insert(
        'flashcards',
        _toRow(c),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int> count() async {
    final db = await _db;
    final result = await db.rawQuery('SELECT COUNT(*) as c FROM flashcards');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Flashcard>> getByModule(WsetModule module) async {
    final db = await _db;
    final rows = await db
        .query('flashcards', where: 'module = ?', whereArgs: [module.name]);
    return rows.map(_fromRow).toList();
  }

  Future<List<Flashcard>> getByTopic(String topicId) async {
    final db = await _db;
    final rows = await db.query(
      'flashcards',
      where: 'topicIds LIKE ?',
      whereArgs: ['%$topicId%'],
    );
    return rows
        .map(_fromRow)
        .where((f) => f.topicIds.contains(topicId))
        .toList();
  }

  Future<Flashcard?> getById(String id) async {
    final db = await _db;
    final rows = await db.query('flashcards', where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return _fromRow(rows.first);
  }
}
