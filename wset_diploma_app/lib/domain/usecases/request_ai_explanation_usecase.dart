import '../../core/services/ai_explanation_service.dart';
import '../entities/question.dart';

/// Asks the AI explanation service to elaborate on why an answer is right
/// or wrong, seeded with the question's own curated [Question.explanation]
/// so the model expands on vetted content instead of inventing facts from
/// scratch.
class RequestAiExplanationUseCase {
  final AiExplanationService aiExplanationService;

  RequestAiExplanationUseCase({required this.aiExplanationService});

  Future<String> call({
    required Question question,
    required List<int> learnerSelectedOptionIndexes,
    String? followUpQuestion,
  }) {
    return aiExplanationService.explain(
      AiExplanationRequest(
        questionPrompt: question.prompt,
        options: question.options,
        correctOptionIndexes: question.correctOptionIndexes,
        learnerSelectedOptionIndexes: learnerSelectedOptionIndexes,
        curatedExplanation: question.explanation,
        followUpQuestion: followUpQuestion,
      ),
    );
  }
}
