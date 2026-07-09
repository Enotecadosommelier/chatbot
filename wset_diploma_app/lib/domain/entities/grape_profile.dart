class GrapeProfile {
  final String id;
  final String name;
  final List<String> synonyms;
  final String colour; // white / black / grey
  final List<String> keyRegions;
  final String viticultureNotes;
  final String vinificationNotes;
  final List<String> typicalAromaDescriptors;
  final String bodyProfile;
  final String acidityProfile;
  final String tanninProfile; // n/a for white grapes
  final String imageAssetPath;

  const GrapeProfile({
    required this.id,
    required this.name,
    required this.synonyms,
    required this.colour,
    required this.keyRegions,
    required this.viticultureNotes,
    required this.vinificationNotes,
    required this.typicalAromaDescriptors,
    required this.bodyProfile,
    required this.acidityProfile,
    required this.tanninProfile,
    required this.imageAssetPath,
  });
}
