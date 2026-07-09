import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../state/feature_providers.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search questions, grapes, regions…',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).state = value,
        ),
      ),
      body: resultsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Search failed: $e')),
        data: (results) {
          if (results.isEmpty) {
            return const Center(
                child: Text('Type to search across the whole app.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (results.grapes.isNotEmpty) ...[
                Text('Grapes', style: Theme.of(context).textTheme.titleMedium),
                for (final g in results.grapes) ListTile(title: Text(g.name)),
              ],
              if (results.regions.isNotEmpty) ...[
                Text('Regions', style: Theme.of(context).textTheme.titleMedium),
                for (final r in results.regions)
                  ListTile(title: Text(r.name), subtitle: Text(r.country)),
              ],
              if (results.questions.isNotEmpty) ...[
                Text('Questions',
                    style: Theme.of(context).textTheme.titleMedium),
                for (final q in results.questions)
                  ListTile(
                    title: Text(q.prompt,
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(q.module.info.code),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}
