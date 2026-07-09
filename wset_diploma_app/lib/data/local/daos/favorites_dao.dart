import 'package:sqflite/sqflite.dart';

import '../../../domain/repositories/favorites_repository.dart';
import '../app_database.dart';

class FavoritesDao {
  Future<Database> get _db => AppDatabase.instance.database;

  Future<List<FavoriteItem>> getAll(String userId) async {
    final db = await _db;
    final rows =
        await db.query('favorites', where: 'userId = ?', whereArgs: [userId]);
    return rows
        .map(
          (r) => FavoriteItem(
            itemId: r['itemId']! as String,
            type: FavoriteItemType.values.byName(r['type']! as String),
            addedAt: DateTime.parse(r['addedAt']! as String),
          ),
        )
        .toList();
  }

  Future<bool> isFavorite(
      String userId, String itemId, FavoriteItemType type) async {
    final db = await _db;
    final rows = await db.query(
      'favorites',
      where: 'userId = ? AND itemId = ? AND type = ?',
      whereArgs: [userId, itemId, type.name],
    );
    return rows.isNotEmpty;
  }

  Future<void> toggle(
      String userId, String itemId, FavoriteItemType type) async {
    final db = await _db;
    final isFav = await isFavorite(userId, itemId, type);
    if (isFav) {
      await db.delete(
        'favorites',
        where: 'userId = ? AND itemId = ? AND type = ?',
        whereArgs: [userId, itemId, type.name],
      );
    } else {
      await db.insert('favorites', {
        'userId': userId,
        'itemId': itemId,
        'type': type.name,
        'addedAt': DateTime.now().toIso8601String(),
      });
    }
  }
}
