import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/wset_modules.dart';
import '../../core/theme/app_colors.dart';
import '../state/feature_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(performanceReportProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Could not load statistics: $e')),
        data: (report) {
          final modulesWithData =
              report.byModule.where((m) => m.attempts > 0).toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Accuracy by module',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: modulesWithData.isEmpty
                    ? const Center(
                        child: Text('Answer some questions to see stats here.'))
                    : BarChart(
                        BarChartData(
                          maxY: 1,
                          barGroups: [
                            for (var i = 0; i < report.byModule.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: report.byModule[i].accuracy,
                                    color: AppColors.bordeaux,
                                    width: 22,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ],
                              ),
                          ],
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 ||
                                      index >= report.byModule.length) {
                                    return const SizedBox.shrink();
                                  }
                                  return Text(
                                      report.byModule[index].module.info.code);
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true, reservedSize: 32),
                            ),
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 24),
              Text('Weakest topics',
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              for (final moduleStats in report.byModule)
                for (final topic in moduleStats.weakestTopics)
                  Card(
                    child: ListTile(
                      title: Text(topic.topicId),
                      subtitle: Text(
                        '${moduleStats.module.info.code} · ${topic.correct}/${topic.attempts} correct',
                      ),
                      trailing: Text('${(topic.accuracy * 100).round()}%'),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
