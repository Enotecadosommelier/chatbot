import '../../core/constants/wset_modules.dart';

/// A front/back study card, independent from quiz [Question]s so flashcard
/// decks can cover pure recall content (grape synonyms, appellation rules,
/// key facts) without forcing everything into a multiple-choice shape.
class Flashcard {
  final String id;
  final WsetModule module;
  final List<String> topicIds;
  final String front;
  final String back;
  final String? imageAssetPath;

  const Flashcard({
    required this.id,
    required this.module,
    required this.topicIds,
    required this.front,
    required this.back,
    this.imageAssetPath,
  });
}
