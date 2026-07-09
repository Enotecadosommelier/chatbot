import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/favorites_repository.dart';
import '../state/feature_providers.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favoritesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load favorites: $e')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(
                child: Text(
                    'Nothing saved yet. Tap the heart icon on a question, flashcard, or profile to save it here.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: items
                .map(
                  (item) => Card(
                    child: ListTile(
                      leading: Icon(_iconFor(item.type)),
                      title: Text(item.itemId),
                      subtitle: Text(item.type.name),
                    ),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }

  IconData _iconFor(FavoriteItemType type) => switch (type) {
        FavoriteItemType.question => Icons.quiz,
        FavoriteItemType.flashcard => Icons.style,
        FavoriteItemType.grapeProfile => Icons.grass,
        FavoriteItemType.regionProfile => Icons.public,
      };
}
