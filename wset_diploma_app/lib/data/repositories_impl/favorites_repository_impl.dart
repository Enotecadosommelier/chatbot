import '../../domain/repositories/favorites_repository.dart';
import '../local/daos/favorites_dao.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesDao dao;

  FavoritesRepositoryImpl({required this.dao});

  @override
  Future<List<FavoriteItem>> getAll(String userId) => dao.getAll(userId);

  @override
  Future<bool> isFavorite(
          String userId, String itemId, FavoriteItemType type) =>
      dao.isFavorite(userId, itemId, type);

  @override
  Future<void> toggle(String userId, String itemId, FavoriteItemType type) =>
      dao.toggle(userId, itemId, type);
}
