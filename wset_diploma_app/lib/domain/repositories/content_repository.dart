import '../entities/grape_profile.dart';
import '../entities/region_profile.dart';

abstract class ContentRepository {
  Future<List<GrapeProfile>> getAllGrapeProfiles();
  Future<GrapeProfile?> getGrapeProfile(String id);
  Future<List<RegionProfile>> getAllRegionProfiles();
  Future<RegionProfile?> getRegionProfile(String id);
  Future<List<GrapeProfile>> searchGrapes(String query);
  Future<List<RegionProfile>> searchRegions(String query);
}
