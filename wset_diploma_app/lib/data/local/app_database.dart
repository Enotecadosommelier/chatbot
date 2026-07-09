import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Single offline-first SQLite database backing every local repository.
///
/// All reads in the app go through this local store first — remote sync
/// (Supabase for content, Firestore for the global leaderboard) only
/// upserts into these tables when connectivity allows, so the quiz,
/// flashcards, and mock exams all keep working with no network at all.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const int schemaVersion = 1;

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'wset_diploma.db');
    return openDatabase(
      path,
      version: schemaVersion,
      onCreate: (db, version) async {
        final batch = db.batch();
        _createSchema(batch);
        await batch.commit(noResult: true);
      },
    );
  }

  void _createSchema(Batch batch) {
    batch.execute('''
      CREATE TABLE questions (
        id TEXT PRIMARY KEY,
        module TEXT NOT NULL,
        topicIds TEXT NOT NULL,
        type TEXT NOT NULL,
        difficulty INTEGER NOT NULL,
        prompt TEXT NOT NULL,
        options TEXT NOT NULL,
        correctOptionIndexes TEXT NOT NULL,
        modelShortAnswer TEXT NOT NULL,
        explanation TEXT NOT NULL,
        imageAssetPaths TEXT NOT NULL,
        references_ TEXT NOT NULL,
        tags TEXT NOT NULL
      );
    ''');
    batch.execute('CREATE INDEX idx_questions_module ON questions(module);');

    batch.execute('''
      CREATE TABLE flashcards (
        id TEXT PRIMARY KEY,
        module TEXT NOT NULL,
        topicIds TEXT NOT NULL,
        front TEXT NOT NULL,
        back TEXT NOT NULL,
        imageAssetPath TEXT
      );
    ''');
    batch.execute('CREATE INDEX idx_flashcards_module ON flashcards(module);');

    batch.execute('''
      CREATE TABLE srs_states (
        cardId TEXT PRIMARY KEY,
        easinessFactor REAL NOT NULL,
        repetitions INTEGER NOT NULL,
        intervalDays INTEGER NOT NULL,
        dueAt TEXT NOT NULL,
        totalReviews INTEGER NOT NULL,
        correctReviews INTEGER NOT NULL
      );
    ''');
    batch.execute('CREATE INDEX idx_srs_due ON srs_states(dueAt);');

    batch.execute('''
      CREATE TABLE topic_mastery (
        userId TEXT NOT NULL,
        topicId TEXT NOT NULL,
        module TEXT NOT NULL,
        attempts INTEGER NOT NULL,
        correct INTEGER NOT NULL,
        lastAttemptAt TEXT NOT NULL,
        PRIMARY KEY (userId, topicId)
      );
    ''');

    batch.execute('''
      CREATE TABLE user_progress (
        userId TEXT PRIMARY KEY,
        totalXp INTEGER NOT NULL,
        currentStreakDays INTEGER NOT NULL,
        longestStreakDays INTEGER NOT NULL,
        lastStudiedAt TEXT
      );
    ''');

    batch.execute('''
      CREATE TABLE unlocked_achievements (
        userId TEXT NOT NULL,
        achievementId TEXT NOT NULL,
        unlockedAt TEXT NOT NULL,
        PRIMARY KEY (userId, achievementId)
      );
    ''');

    batch.execute('''
      CREATE TABLE favorites (
        userId TEXT NOT NULL,
        itemId TEXT NOT NULL,
        type TEXT NOT NULL,
        addedAt TEXT NOT NULL,
        PRIMARY KEY (userId, itemId, type)
      );
    ''');

    batch.execute('''
      CREATE TABLE study_plan_sessions (
        userId TEXT NOT NULL,
        date TEXT NOT NULL,
        module TEXT NOT NULL,
        focusTopicId TEXT NOT NULL,
        plannedDurationSeconds INTEGER NOT NULL,
        completed INTEGER NOT NULL,
        PRIMARY KEY (userId, date)
      );
    ''');
  }

  /// Test-only: allows widget/unit tests to inject an in-memory database
  /// instead of touching the platform channel.
  void debugOverrideDatabase(Database db) {
    _db = db;
  }
}
