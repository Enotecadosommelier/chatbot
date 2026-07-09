import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../core/config/app_config.dart';
import '../../core/services/ai_explanation_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/user_identity_service.dart';
import '../../data/local/app_database.dart';
import '../../data/local/daos/achievement_dao.dart';
import '../../data/local/daos/favorites_dao.dart';
import '../../data/local/daos/flashcard_dao.dart';
import '../../data/local/daos/progress_dao.dart';
import '../../data/local/daos/question_dao.dart';
import '../../data/local/daos/study_plan_dao.dart';
import '../../data/remote/ai_explanation_remote_datasource.dart';
import '../../data/remote/firebase_leaderboard_datasource.dart';
import '../../data/remote/supabase_question_datasource.dart';
import '../../data/repositories_impl/achievement_repository_impl.dart';
import '../../data/repositories_impl/content_repository_impl.dart';
import '../../data/repositories_impl/favorites_repository_impl.dart';
import '../../data/repositories_impl/flashcard_repository_impl.dart';
import '../../data/repositories_impl/leaderboard_repository_impl.dart';
import '../../data/repositories_impl/progress_repository_impl.dart';
import '../../data/repositories_impl/question_repository_impl.dart';
import '../../data/repositories_impl/study_plan_repository_impl.dart';
import '../../data/seed/seed_loader.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../../domain/repositories/flashcard_repository.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../../domain/repositories/progress_repository.dart';
import '../../domain/repositories/question_repository.dart';
import '../../domain/repositories/study_plan_repository.dart';
import '../../domain/usecases/compare_sat_note_usecase.dart';
import '../../domain/usecases/generate_mock_exam_usecase.dart';
import '../../domain/usecases/generate_study_plan_usecase.dart';
import '../../domain/usecases/get_adaptive_quiz_session_usecase.dart';
import '../../domain/usecases/get_performance_statistics_usecase.dart';
import '../../domain/usecases/request_ai_explanation_usecase.dart';
import '../../domain/usecases/review_flashcard_usecase.dart';
import '../../domain/usecases/search_content_usecase.dart';
import '../../domain/usecases/submit_quiz_answer_usecase.dart';
import '../../domain/usecases/toggle_favorite_usecase.dart';

// --- Infrastructure --------------------------------------------------

final connectivityServiceProvider = Provider((ref) => ConnectivityService());

/// Non-null only when SUPABASE_URL/SUPABASE_ANON_KEY were supplied at
/// build time (see docs/FIREBASE_SUPABASE_SETUP.md). The app must keep
/// working with this null — that's what makes it offline-first rather
/// than offline-broken.
final supabaseQuestionDataSourceProvider =
    Provider<SupabaseQuestionDataSource?>((ref) {
  if (!AppConfig.hasSupabaseConfig) return null;
  return SupabaseQuestionDataSource(Supabase.instance.client);
});

final firebaseLeaderboardDataSourceProvider =
    Provider<FirebaseLeaderboardDataSource?>((ref) {
  if (Firebase.apps.isEmpty) return null;
  return FirebaseLeaderboardDataSource(FirebaseFirestore.instance);
});

final aiExplanationServiceProvider = Provider<AiExplanationService>((ref) {
  return AiExplanationRemoteDataSource(
      endpoint: AppConfig.aiExplanationEndpoint);
});

// --- DAOs --------------------------------------------------------------

final questionDaoProvider = Provider((ref) => QuestionDao());
final flashcardDaoProvider = Provider((ref) => FlashcardDao());
final progressDaoProvider = Provider((ref) => ProgressDao());
final achievementDaoProvider = Provider((ref) => AchievementDao());
final favoritesDaoProvider = Provider((ref) => FavoritesDao());
final studyPlanDaoProvider = Provider((ref) => StudyPlanDao());

// --- Repositories --------------------------------------------------------

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl(
    dao: ref.watch(questionDaoProvider),
    remoteDataSource: ref.watch(supabaseQuestionDataSourceProvider),
  );
});

final flashcardRepositoryProvider = Provider<FlashcardRepository>((ref) {
  return FlashcardRepositoryImpl(dao: ref.watch(flashcardDaoProvider));
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  return ProgressRepositoryImpl(
    dao: ref.watch(progressDaoProvider),
    questionRepository: ref.watch(questionRepositoryProvider),
  );
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepositoryImpl(dao: ref.watch(achievementDaoProvider));
});

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl(dao: ref.watch(favoritesDaoProvider));
});

final studyPlanRepositoryProvider = Provider<StudyPlanRepository>((ref) {
  return StudyPlanRepositoryImpl(dao: ref.watch(studyPlanDaoProvider));
});

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepositoryImpl(
    remote: ref.watch(firebaseLeaderboardDataSourceProvider),
  );
});

final contentRepositoryProvider = Provider<ContentRepository>((ref) {
  return ContentRepositoryImpl();
});

// --- Use cases -----------------------------------------------------------

final getAdaptiveQuizSessionUseCaseProvider = Provider((ref) {
  return GetAdaptiveQuizSessionUseCase(
    questionRepository: ref.watch(questionRepositoryProvider),
    progressRepository: ref.watch(progressRepositoryProvider),
  );
});

final submitQuizAnswerUseCaseProvider = Provider((ref) {
  return SubmitQuizAnswerUseCase(
      progressRepository: ref.watch(progressRepositoryProvider));
});

final reviewFlashcardUseCaseProvider = Provider((ref) {
  return ReviewFlashcardUseCase(
      progressRepository: ref.watch(progressRepositoryProvider));
});

final generateMockExamUseCaseProvider = Provider((ref) {
  return GenerateMockExamUseCase(
      questionRepository: ref.watch(questionRepositoryProvider));
});

final compareSatNoteUseCaseProvider =
    Provider((ref) => CompareSatNoteUseCase());

final getPerformanceStatisticsUseCaseProvider = Provider((ref) {
  return GetPerformanceStatisticsUseCase(
    progressRepository: ref.watch(progressRepositoryProvider),
  );
});

final generateStudyPlanUseCaseProvider = Provider((ref) {
  return GenerateStudyPlanUseCase(
    progressRepository: ref.watch(progressRepositoryProvider),
    studyPlanRepository: ref.watch(studyPlanRepositoryProvider),
  );
});

final searchContentUseCaseProvider = Provider((ref) {
  return SearchContentUseCase(
    questionRepository: ref.watch(questionRepositoryProvider),
    contentRepository: ref.watch(contentRepositoryProvider),
  );
});

final toggleFavoriteUseCaseProvider = Provider((ref) {
  return ToggleFavoriteUseCase(
      favoritesRepository: ref.watch(favoritesRepositoryProvider));
});

final requestAiExplanationUseCaseProvider = Provider((ref) {
  return RequestAiExplanationUseCase(
    aiExplanationService: ref.watch(aiExplanationServiceProvider),
  );
});

// --- App bootstrap / identity --------------------------------------------

final currentUserIdProvider = FutureProvider<String>((ref) async {
  return UserIdentityService().getOrCreateLocalUserId();
});

/// Seeds the local database (idempotent) and kicks off a best-effort
/// background sync from Supabase. Awaited once from a splash/loading
/// screen before the rest of the app reads question data.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  await AppDatabase.instance.database;
  final seedLoader = SeedLoader(
    questionDao: ref.watch(questionDaoProvider),
    flashcardDao: ref.watch(flashcardDaoProvider),
  );
  await seedLoader.seedIfEmpty();

  final isOnline = await ref.watch(connectivityServiceProvider).isOnline;
  if (isOnline) {
    // Best-effort: sync failures shouldn't block app startup.
    unawaited(ref.watch(questionRepositoryProvider).syncFromRemote());
  }
});
