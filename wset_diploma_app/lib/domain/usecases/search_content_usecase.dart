import '../entities/grape_profile.dart';
import '../entities/question.dart';
import '../entities/region_profile.dart';
import '../repositories/content_repository.dart';
import '../repositories/question_repository.dart';

class SearchResults {
  final List<Question> questions;
  final List<GrapeProfile> grapes;
  final List<RegionProfile> regions;

  const SearchResults({
    required this.questions,
    required this.grapes,
    required this.regions,
  });

  bool get isEmpty => questions.isEmpty && grapes.isEmpty && regions.isEmpty;
}

/// Fans a single search query out across questions, grape profiles, and
/// region profiles so the Search screen can show unified, categorised
/// results instead of forcing the learner to guess which tab to search in.
class SearchContentUseCase {
  final QuestionRepository questionRepository;
  final ContentRepository contentRepository;

  SearchContentUseCase({
    required this.questionRepository,
    required this.contentRepository,
  });

  Future<SearchResults> call(String query) async {
    if (query.trim().isEmpty) {
      return const SearchResults(questions: [], grapes: [], regions: []);
    }

    final results = await Future.wait([
      questionRepository.search(query),
      contentRepository.searchGrapes(query),
      contentRepository.searchRegions(query),
    ]);

    return SearchResults(
      questions: results[0] as List<Question>,
      grapes: results[1] as List<GrapeProfile>,
      regions: results[2] as List<RegionProfile>,
    );
  }
}
