enum AchievementCategory { streak, mastery, volume, exam, exploration }

class Achievement {
  final String id;
  final String title;
  final String description;
  final AchievementCategory category;
  final String iconAssetPath;
  final int xpReward;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.iconAssetPath,
    required this.xpReward,
  });
}

class UnlockedAchievement {
  final String achievementId;
  final DateTime unlockedAt;

  const UnlockedAchievement({
    required this.achievementId,
    required this.unlockedAt,
  });
}
