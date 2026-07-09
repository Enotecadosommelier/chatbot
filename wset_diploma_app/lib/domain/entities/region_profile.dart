import '../../core/constants/wset_modules.dart';

class RegionProfile {
  final String id;
  final String name;
  final String country;
  final WsetModule primaryModule;
  final String climate;
  final String soils;
  final List<String> keyGrapes;
  final List<String> appellations;
  final String qualityClassification;
  final String styleSummary;
  final String mapAssetPath;

  const RegionProfile({
    required this.id,
    required this.name,
    required this.country,
    required this.primaryModule,
    required this.climate,
    required this.soils,
    required this.keyGrapes,
    required this.appellations,
    required this.qualityClassification,
    required this.styleSummary,
    required this.mapAssetPath,
  });
}
