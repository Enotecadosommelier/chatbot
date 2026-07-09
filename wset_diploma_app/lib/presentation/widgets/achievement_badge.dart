import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../domain/entities/achievement.dart';

class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool unlocked;

  const AchievementBadge(
      {super.key, required this.achievement, required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1 : 0.4,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor:
                    unlocked ? AppColors.gold : Colors.grey.shade400,
                child: Icon(
                  unlocked ? Icons.emoji_events : Icons.lock,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                achievement.description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '+${achievement.xpReward} XP',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.bordeaux, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
