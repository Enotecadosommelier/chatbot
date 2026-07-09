import 'package:flutter/material.dart';

import '../../core/constants/wset_modules.dart';
import '../../core/theme/app_colors.dart';

class ModuleCard extends StatelessWidget {
  final WsetModule module;
  final VoidCallback onTap;
  final double? accuracy;

  const ModuleCard(
      {super.key, required this.module, required this.onTap, this.accuracy});

  @override
  Widget build(BuildContext context) {
    final info = module.info;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.bordeaux,
                foregroundColor: Colors.white,
                child: Text(info.code),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(info.title,
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      info.assessmentFormat,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (accuracy != null) ...[
                const SizedBox(width: 8),
                Text(
                  '${(accuracy! * 100).round()}%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.gold, fontWeight: FontWeight.bold),
                ),
              ],
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
