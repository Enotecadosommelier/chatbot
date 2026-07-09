import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/question.dart';
import 'question_row_mapper.dart';

/// Reads the shared, growing question bank from a Supabase Postgres table.
///
/// This is where the path to 10,000+ questions actually lives: Supabase
/// holds the canonical, continuously-authored bank; the local SQLite store
/// (see AppDatabase) is just an offline cache synced from here. See
/// docs/CONTENT_ROADMAP.md for the authoring pipeline and the `questions`
/// table DDL.
class SupabaseQuestionDataSource {
  final SupabaseClient client;

  SupabaseQuestionDataSource(this.client);

  static const _table = 'questions';

  /// Fetches every row with `updated_at` after [since], for incremental
  /// sync. Pass null to do a full pull (e.g. first launch after install).
  Future<List<Question>> fetchUpdatedSince(DateTime? since) async {
    var query = client.from(_table).select();
    if (since != null) {
      query = query.gt('updated_at', since.toIso8601String());
    }
    final rows = await query;
    return (rows as List)
        .map((row) => mapSupabaseRowToQuestion(row as Map<String, dynamic>))
        .toList();
  }
}
