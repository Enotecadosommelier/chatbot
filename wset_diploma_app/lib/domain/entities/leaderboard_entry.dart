class LeaderboardEntry {
  final String userId;
  final String displayName;
  final int totalXp;
  final int rank;
  final String? avatarUrl;

  const LeaderboardEntry({
    required this.userId,
    required this.displayName,
    required this.totalXp,
    required this.rank,
    this.avatarUrl,
  });
}
