import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/feature_providers.dart';
import '../widgets/achievement_badge.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final definitionsAsync = ref.watch(achievementDefinitionsProvider);
    final unlockedAsync = ref.watch(unlockedAchievementsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: definitionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load achievements: $e')),
        data: (definitions) {
          final unlockedIds =
              unlockedAsync.value?.map((u) => u.achievementId).toSet() ??
                  <String>{};

          return GridView.count(
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            childAspectRatio: 0.85,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children: definitions
                .map(
                  (a) => AchievementBadge(
                    achievement: a,
                    unlocked: unlockedIds.contains(a.id),
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
