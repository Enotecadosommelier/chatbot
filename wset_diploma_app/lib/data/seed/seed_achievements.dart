import '../../domain/entities/achievement.dart';

final List<Achievement> kSeedAchievements = [
  const Achievement(
    id: 'ach-first-quiz',
    title: 'First Pour',
    description: 'Complete your first quiz session.',
    category: AchievementCategory.volume,
    iconAssetPath: 'assets/images/achievements/first_pour.png',
    xpReward: 25,
  ),
  const Achievement(
    id: 'ach-streak-7',
    title: 'Steady Hand',
    description: 'Study for 7 days in a row.',
    category: AchievementCategory.streak,
    iconAssetPath: 'assets/images/achievements/steady_hand.png',
    xpReward: 100,
  ),
  const Achievement(
    id: 'ach-streak-30',
    title: 'Vintage Discipline',
    description: 'Study for 30 days in a row.',
    category: AchievementCategory.streak,
    iconAssetPath: 'assets/images/achievements/vintage_discipline.png',
    xpReward: 500,
  ),
  const Achievement(
    id: 'ach-d1-mastery',
    title: 'Cellar Scientist',
    description:
        'Reach 90%+ rolling accuracy across all D1 topics (min. 30 attempts).',
    category: AchievementCategory.mastery,
    iconAssetPath: 'assets/images/achievements/cellar_scientist.png',
    xpReward: 300,
  ),
  const Achievement(
    id: 'ach-mock-exam-pass',
    title: 'Exam Ready',
    description: 'Score 55% or higher on a full-length mock exam.',
    category: AchievementCategory.exam,
    iconAssetPath: 'assets/images/achievements/exam_ready.png',
    xpReward: 250,
  ),
  const Achievement(
    id: 'ach-sat-first',
    title: 'Systematic Taster',
    description: 'Complete your first SAT simulator tasting note.',
    category: AchievementCategory.exploration,
    iconAssetPath: 'assets/images/achievements/systematic_taster.png',
    xpReward: 50,
  ),
  const Achievement(
    id: 'ach-explorer-regions',
    title: 'World Traveller',
    description: 'View 20 different region profiles.',
    category: AchievementCategory.exploration,
    iconAssetPath: 'assets/images/achievements/world_traveller.png',
    xpReward: 75,
  ),
  const Achievement(
    id: 'ach-1000-reviews',
    title: 'Thousand and One Nights',
    description: 'Complete 1,000 spaced-repetition reviews.',
    category: AchievementCategory.volume,
    iconAssetPath: 'assets/images/achievements/thousand_reviews.png',
    xpReward: 400,
  ),
];
