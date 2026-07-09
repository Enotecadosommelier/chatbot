/// AI-powered "explain this answer" feature.
///
/// The service intentionally never calls a third-party LLM API directly
/// from the client with an embedded key — that would leak credentials in
/// the shipped APK. Instead it calls a thin backend endpoint (a Supabase
/// Edge Function or Firebase Cloud Function you deploy yourself) which
/// holds the model API key server-side. See docs/AI_EXPLANATION_BACKEND.md
/// for a reference implementation of that function.
class AiExplanationRequest {
  final String questionPrompt;
  final List<String> options;
  final List<int> correctOptionIndexes;
  final List<int> learnerSelectedOptionIndexes;
  final String curatedExplanation;
  final String? followUpQuestion;

  const AiExplanationRequest({
    required this.questionPrompt,
    required this.options,
    required this.correctOptionIndexes,
    required this.learnerSelectedOptionIndexes,
    required this.curatedExplanation,
    this.followUpQuestion,
  });
}

abstract class AiExplanationService {
  Future<String> explain(AiExplanationRequest request);
}
