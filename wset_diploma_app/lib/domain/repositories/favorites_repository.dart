enum FavoriteItemType { question, flashcard, grapeProfile, regionProfile }

class FavoriteItem {
  final String itemId;
  final FavoriteItemType type;
  final DateTime addedAt;

  const FavoriteItem({
    required this.itemId,
    required this.type,
    required this.addedAt,
  });
}

abstract class FavoritesRepository {
  Future<List<FavoriteItem>> getAll(String userId);
  Future<bool> isFavorite(String userId, String itemId, FavoriteItemType type);
  Future<void> toggle(String userId, String itemId, FavoriteItemType type);
}
