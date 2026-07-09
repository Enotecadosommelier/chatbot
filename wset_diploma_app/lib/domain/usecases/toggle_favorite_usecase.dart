import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository favoritesRepository;

  ToggleFavoriteUseCase({required this.favoritesRepository});

  Future<void> call(String userId, String itemId, FavoriteItemType type) {
    return favoritesRepository.toggle(userId, itemId, type);
  }
}
