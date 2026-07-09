import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// Maps a Supabase `questions` row (snake_case JSON) to the domain
/// [Question] entity. Kept separate from [Question.fromMap] because the
/// wire format (Postgres/JSON) and the local SQLite row format intentionally
/// differ — this is the one seam that has to track the remote schema.
Question mapSupabaseRowToQuestion(Map<String, dynamic> row) {
  return Question(
    id: row['id'] as String,
    module: WsetModule.values.byName(row['module'] as String),
    topicIds: List<String>.from(row['topic_ids'] as List? ?? const []),
    type: QuestionType.values.byName(row['type'] as String),
    difficulty: row['difficulty'] as int,
    prompt: row['prompt'] as String,
    options: List<String>.from(row['options'] as List? ?? const []),
    correctOptionIndexes:
        List<int>.from(row['correct_option_indexes'] as List? ?? const []),
    modelShortAnswer: row['model_short_answer'] as String? ?? '',
    explanation: row['explanation'] as String,
    imageAssetPaths:
        List<String>.from(row['image_asset_paths'] as List? ?? const []),
    references: List<String>.from(row['references'] as List? ?? const []),
    tags: List<String>.from(row['tags'] as List? ?? const []),
  );
}
