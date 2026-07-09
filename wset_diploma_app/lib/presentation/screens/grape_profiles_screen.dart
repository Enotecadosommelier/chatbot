import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/grape_profile.dart';
import '../state/feature_providers.dart';

class GrapeProfilesScreen extends ConsumerWidget {
  const GrapeProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grapesAsync = ref.watch(grapeProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Grape Profiles')),
      body: grapesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Could not load grape profiles: $e')),
        data: (grapes) => ListView.builder(
          itemCount: grapes.length,
          itemBuilder: (context, index) {
            final grape = grapes[index];
            return ListTile(
              title: Text(grape.name),
              subtitle: Text(grape.keyRegions.take(2).join(', ')),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => GrapeProfileDetailScreen(grape: grape)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GrapeProfileDetailScreen extends StatelessWidget {
  final GrapeProfile grape;

  const GrapeProfileDetailScreen({super.key, required this.grape});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(grape.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Key regions', body: grape.keyRegions.join(', ')),
          _Section(title: 'Viticulture', body: grape.viticultureNotes),
          _Section(title: 'Vinification', body: grape.vinificationNotes),
          _Section(
              title: 'Typical aroma descriptors',
              body: grape.typicalAromaDescriptors.join(', ')),
          _Section(
            title: 'Structure',
            body:
                'Body: ${grape.bodyProfile}\nAcidity: ${grape.acidityProfile}\nTannin: ${grape.tanninProfile}',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(body),
        ],
      ),
    );
  }
}
