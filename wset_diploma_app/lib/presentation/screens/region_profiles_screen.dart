import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/region_profile.dart';
import '../state/feature_providers.dart';

class RegionProfilesScreen extends ConsumerWidget {
  const RegionProfilesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final regionsAsync = ref.watch(regionProfilesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Region Profiles')),
      body: regionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Could not load region profiles: $e')),
        data: (regions) => ListView.builder(
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];
            return ListTile(
              title: Text(region.name),
              subtitle: Text(region.country),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                    builder: (_) => RegionProfileDetailScreen(region: region)),
              ),
            );
          },
        ),
      ),
    );
  }
}

class RegionProfileDetailScreen extends StatelessWidget {
  final RegionProfile region;

  const RegionProfileDetailScreen({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(region.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _Section(title: 'Climate', body: region.climate),
          _Section(title: 'Soils', body: region.soils),
          _Section(title: 'Key grapes', body: region.keyGrapes.join(', ')),
          _Section(title: 'Appellations', body: region.appellations.join(', ')),
          _Section(
              title: 'Quality classification',
              body: region.qualityClassification),
          _Section(title: 'Style summary', body: region.styleSummary),
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
