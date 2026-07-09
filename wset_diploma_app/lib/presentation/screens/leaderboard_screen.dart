import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../state/feature_providers.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(globalLeaderboardProvider);
    final rankAsync = ref.watch(userLeaderboardRankProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Global Leaderboard')),
      body: leaderboardAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load leaderboard: $e')),
        data: (entries) {
          if (entries.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Leaderboard needs an internet connection and a configured '
                  'Firebase project (see docs/FIREBASE_SUPABASE_SETUP.md).\n\n'
                  'Your local progress and XP are unaffected — they always work offline.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Column(
            children: [
              rankAsync.when(
                data: (rank) => rank == null
                    ? const SizedBox.shrink()
                    : Card(
                        margin: const EdgeInsets.all(16),
                        color: AppColors.gold.withValues(alpha: 0.15),
                        child: ListTile(
                          leading: const Icon(Icons.person),
                          title: Text('Your rank: #${rank.rank}'),
                          trailing: Text('${rank.totalXp} XP'),
                        ),
                      ),
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return ListTile(
                      leading: CircleAvatar(child: Text('${entry.rank}')),
                      title: Text(entry.displayName),
                      trailing: Text('${entry.totalXp} XP'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
