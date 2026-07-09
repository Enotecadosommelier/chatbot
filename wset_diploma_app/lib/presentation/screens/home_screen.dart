import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../state/feature_providers.dart';
import '../widgets/module_card.dart';
import '../widgets/stat_tile.dart';
import 'achievements_screen.dart';
import 'favorites_screen.dart';
import 'flashcards_screen.dart';
import 'grape_profiles_screen.dart';
import 'leaderboard_screen.dart';
import 'mock_exam_screen.dart';
import 'quiz_screen.dart';
import 'region_profiles_screen.dart';
import 'sat_simulator_screen.dart';
import 'search_screen.dart';
import 'statistics_screen.dart';
import 'study_plan_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(performanceReportProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('WSET Diploma Prep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const FavoritesScreen()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(performanceReportProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            reportAsync.when(
              data: (report) => Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: 'Level ${report.userProgress.level}',
                      value: '${report.userProgress.totalXp} XP',
                      icon: Icons.emoji_events,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: StatTile(
                      label: 'Day streak',
                      value: '${report.userProgress.currentStreakDays}',
                      icon: Icons.local_fire_department,
                    ),
                  ),
                ],
              ),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Could not load progress: $e'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Adaptive Quiz'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const QuizScreen()),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.style),
                    label: const Text('Flashcards'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => const FlashcardsScreen()),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Study by module',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...WsetModule.values.map((module) {
              final accuracy = reportAsync.value?.byModule
                  .firstWhere((m) => m.module == module)
                  .accuracy;
              return ModuleCard(
                module: module,
                accuracy: accuracy,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                      builder: (_) => QuizScreen(module: module)),
                ),
              );
            }),
            const SizedBox(height: 24),
            Text('More tools', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const _ToolsGrid(),
          ],
        ),
      ),
    );
  }
}

class _ToolsGrid extends StatelessWidget {
  const _ToolsGrid();

  @override
  Widget build(BuildContext context) {
    final tools = <(IconData, String, WidgetBuilder)>[
      (Icons.assignment, 'Mock Exam', (_) => const MockExamScreen()),
      (Icons.wine_bar, 'SAT Simulator', (_) => const SatSimulatorScreen()),
      (Icons.bar_chart, 'Statistics', (_) => const StatisticsScreen()),
      (Icons.calendar_month, 'Study Plan', (_) => const StudyPlanScreen()),
      (Icons.leaderboard, 'Leaderboard', (_) => const LeaderboardScreen()),
      (Icons.emoji_events, 'Achievements', (_) => const AchievementsScreen()),
      (Icons.grass, 'Grape Profiles', (_) => const GrapeProfilesScreen()),
      (Icons.public, 'Region Profiles', (_) => const RegionProfilesScreen()),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2.4,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: tools.map((tool) {
        final (icon, label, builder) = tool;
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => Navigator.of(context)
                .push(MaterialPageRoute<void>(builder: builder)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
