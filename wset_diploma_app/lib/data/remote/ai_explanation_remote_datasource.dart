import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/services/ai_explanation_service.dart';

/// Calls a developer-deployed backend endpoint (Supabase Edge Function or
/// Firebase Cloud Function) that wraps a hosted LLM, so no API key is ever
/// embedded in the shipped app. If the request fails for any reason
/// (offline, backend not configured yet, timeout), it falls back to the
/// question's own curated explanation instead of surfacing an error —
/// study material should never go blank because of a network hiccup.
class AiExplanationRemoteDataSource implements AiExplanationService {
  final http.Client httpClient;
  final String endpoint;
  final Duration timeout;

  AiExplanationRemoteDataSource({
    required this.endpoint,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 12),
  }) : httpClient = httpClient ?? http.Client();

  @override
  Future<String> explain(AiExplanationRequest request) async {
    if (endpoint.isEmpty) return request.curatedExplanation;

    try {
      final response = await httpClient
          .post(
            Uri.parse(endpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'question': request.questionPrompt,
              'options': request.options,
              'correctOptionIndexes': request.correctOptionIndexes,
              'learnerSelectedOptionIndexes':
                  request.learnerSelectedOptionIndexes,
              'curatedExplanation': request.curatedExplanation,
              'followUpQuestion': request.followUpQuestion,
            }),
          )
          .timeout(timeout);

      if (response.statusCode != 200) return request.curatedExplanation;

      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final explanation = body['explanation'] as String?;
      return (explanation == null || explanation.trim().isEmpty)
          ? request.curatedExplanation
          : explanation;
    } catch (_) {
      return request.curatedExplanation;
    }
  }
}
