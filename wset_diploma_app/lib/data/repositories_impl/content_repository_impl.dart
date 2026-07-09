import '../../domain/entities/grape_profile.dart';
import '../../domain/entities/region_profile.dart';
import '../../domain/repositories/content_repository.dart';
import '../seed/seed_grape_profiles.dart';
import '../seed/seed_region_profiles.dart';

/// Grape and region profiles are bundled, static reference content (there
/// is no per-user mutation), so this repository serves them straight out
/// of the in-memory seed lists rather than round-tripping through SQLite.
class ContentRepositoryImpl implements ContentRepository {
  @override
  Future<List<GrapeProfile>> getAllGrapeProfiles() async => kSeedGrapeProfiles;

  @override
  Future<GrapeProfile?> getGrapeProfile(String id) async {
    for (final g in kSeedGrapeProfiles) {
      if (g.id == id) return g;
    }
    return null;
  }

  @override
  Future<List<RegionProfile>> getAllRegionProfiles() async =>
      kSeedRegionProfiles;

  @override
  Future<RegionProfile?> getRegionProfile(String id) async {
    for (final r in kSeedRegionProfiles) {
      if (r.id == id) return r;
    }
    return null;
  }

  @override
  Future<List<GrapeProfile>> searchGrapes(String query) async {
    final needle = query.toLowerCase();
    return kSeedGrapeProfiles
        .where(
          (g) =>
              g.name.toLowerCase().contains(needle) ||
              g.synonyms.any((s) => s.toLowerCase().contains(needle)),
        )
        .toList();
  }

  @override
  Future<List<RegionProfile>> searchRegions(String query) async {
    final needle = query.toLowerCase();
    return kSeedRegionProfiles
        .where(
          (r) =>
              r.name.toLowerCase().contains(needle) ||
              r.country.toLowerCase().contains(needle),
        )
        .toList();
  }
}
