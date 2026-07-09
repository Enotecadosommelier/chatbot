import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/leaderboard_entry.dart';

/// Global ranking backed by Firestore. Firebase (rather than Supabase) is
/// used here specifically because Firestore's real-time listeners and
/// battle-tested mobile SDK make a live, thousands-of-concurrent-readers
/// leaderboard simple to scale, while Supabase/Postgres remains the
/// system of record for the (much larger, less frequently changing)
/// question bank.
class FirebaseLeaderboardDataSource {
  final FirebaseFirestore firestore;

  FirebaseLeaderboardDataSource(this.firestore);

  CollectionReference<Map<String, dynamic>> get _collection =>
      firestore.collection('leaderboard');

  Future<List<LeaderboardEntry>> getGlobalTop({int limit = 100}) async {
    final snapshot = await _collection
        .orderBy('totalXp', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.asMap().entries.map((entry) {
      final rank = entry.key + 1;
      final data = entry.value.data();
      return LeaderboardEntry(
        userId: entry.value.id,
        displayName: data['displayName'] as String? ?? 'Anonymous',
        totalXp: data['totalXp'] as int? ?? 0,
        rank: rank,
        avatarUrl: data['avatarUrl'] as String?,
      );
    }).toList();
  }

  Future<void> pushScore(String userId, String displayName, int totalXp) {
    return _collection.doc(userId).set(
      {
        'displayName': displayName,
        'totalXp': totalXp,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  }

  Future<LeaderboardEntry?> getUserRank(String userId) async {
    final doc = await _collection.doc(userId).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    final higherScoreCount = await _collection
        .where('totalXp', isGreaterThan: data['totalXp'] as int? ?? 0)
        .count()
        .get();
    return LeaderboardEntry(
      userId: userId,
      displayName: data['displayName'] as String? ?? 'Anonymous',
      totalXp: data['totalXp'] as int? ?? 0,
      rank: (higherScoreCount.count ?? 0) + 1,
      avatarUrl: data['avatarUrl'] as String?,
    );
  }
}
