import '../../core/constants/wset_modules.dart';
import '../../domain/entities/region_profile.dart';

/// A starter set of major regions covered across D3-D5. Structured
/// identically to [kSeedGrapeProfiles] so it scales the same way — see
/// docs/CONTENT_ROADMAP.md.
final List<RegionProfile> kSeedRegionProfiles = [
  const RegionProfile(
    id: 'region-medoc',
    name: 'Médoc',
    country: 'France',
    primaryModule: WsetModule.d3,
    climate:
        'Moderate maritime, warmed by the Gironde estuary; risk of spring frost and autumn rain.',
    soils:
        'Gravel mounds (croupes) over clay/limestone, providing excellent drainage and heat retention.',
    keyGrapes: [
      'Cabernet Sauvignon',
      'Merlot',
      'Cabernet Franc',
      'Petit Verdot'
    ],
    appellations: [
      'Saint-Estèphe',
      'Pauillac',
      'Saint-Julien',
      'Margaux',
      'Haut-Médoc'
    ],
    qualityClassification:
        '1855 Classification (Grands Crus Classés) and Cru Bourgeois',
    styleSummary:
        'Cabernet Sauvignon-dominant blends: full-bodied, high tannin, blackcurrant/cedar character, built for extended bottle ageing.',
    mapAssetPath: 'assets/images/maps/medoc.png',
  ),
  const RegionProfile(
    id: 'region-cote-dor',
    name: "Côte d'Or",
    country: 'France',
    primaryModule: WsetModule.d3,
    climate:
        'Moderate continental; frost and hail are significant vintage risks.',
    soils:
        'Limestone and marl, varying subtly plot-by-plot — the basis of Burgundy\'s climat system.',
    keyGrapes: ['Pinot Noir', 'Chardonnay'],
    appellations: [
      'Gevrey-Chambertin',
      'Vosne-Romanée',
      'Meursault',
      'Puligny-Montrachet'
    ],
    qualityClassification:
        'Grand Cru, Premier Cru, Village, Regional (Bourgogne)',
    styleSummary:
        'Site-driven, elegant Pinot Noir (Côte de Nuits emphasis) and Chardonnay (Côte de Beaune emphasis), prized for expressing subtle differences between adjacent vineyard plots.',
    mapAssetPath: 'assets/images/maps/cote_dor.png',
  ),
  const RegionProfile(
    id: 'region-mosel',
    name: 'Mosel',
    country: 'Germany',
    primaryModule: WsetModule.d3,
    climate:
        'Cool continental; steep river-valley sites capture reflected sunlight/heat off the river.',
    soils:
        'Devonian slate, which retains and re-radiates heat and drains well on very steep slopes.',
    keyGrapes: ['Riesling'],
    appellations: ['Bernkastel', 'Piesport', 'Wehlen'],
    qualityClassification:
        'Prädikatswein ripeness levels (Kabinett to Trockenbeerenauslese); VDP classified vineyard sites (Grosse Lage etc.) used in parallel',
    styleSummary:
        'Elegant, light-bodied, high-acid Riesling ranging from bone-dry to lusciously sweet, with pronounced minerality attributed in part to the slate soils.',
    mapAssetPath: 'assets/images/maps/mosel.png',
  ),
  const RegionProfile(
    id: 'region-champagne',
    name: 'Champagne',
    country: 'France',
    primaryModule: WsetModule.d4,
    climate:
        'Cool continental/marginal climate — a deliberate choice, since high acidity is essential to the traditional-method style.',
    soils:
        'Chalk subsoil, which provides excellent drainage and water retention in dry periods.',
    keyGrapes: ['Chardonnay', 'Pinot Noir', 'Pinot Meunier'],
    appellations: [
      'Montagne de Reims',
      'Côte des Blancs',
      'Vallée de la Marne',
      "Côte des Bar"
    ],
    qualityClassification:
        'Historic (non-legal) village ranking system (former "Échelle des Crus"); Grand Cru/Premier Cru village reputation still referenced informally',
    styleSummary:
        'The benchmark traditional-method sparkling wine: high acid base wines, extended lees ageing for autolytic complexity, produced across a range of styles from Non-Vintage Brut to prestige cuvées.',
    mapAssetPath: 'assets/images/maps/champagne.png',
  ),
  const RegionProfile(
    id: 'region-jerez',
    name: 'Jerez (Sherry region)',
    country: 'Spain',
    primaryModule: WsetModule.d5,
    climate:
        'Hot, sunny Mediterranean/Atlantic-influenced climate, moderated near the coast by the Poniente wind.',
    soils:
        'Albariza (chalky white soil), prized for water retention through the dry summer.',
    keyGrapes: ['Palomino', 'Pedro Ximénez', 'Moscatel'],
    appellations: ['Jerez-Xérès-Sherry DO'],
    qualityClassification:
        'Solera-based ageing categories (Fino/Manzanilla through to VOS/VORS for very old wines)',
    styleSummary:
        'The full spectrum of fortified Sherry styles, from bone-dry biologically-aged Fino/Manzanilla through oxidatively-aged Oloroso to lusciously sweet Pedro Ximénez.',
    mapAssetPath: 'assets/images/maps/jerez.png',
  ),
  const RegionProfile(
    id: 'region-douro',
    name: 'Douro',
    country: 'Portugal',
    primaryModule: WsetModule.d5,
    climate:
        'Hot, dry continental climate, intensified further upriver; the Serra do Marão mountains block Atlantic influence.',
    soils:
        'Schist, whose fractured structure lets vine roots penetrate deep in search of water.',
    keyGrapes: [
      'Touriga Nacional',
      'Touriga Franca',
      'Tinta Roriz (Tempranillo)'
    ],
    appellations: ['Douro DOC (table wine)', 'Porto DOC (fortified)'],
    qualityClassification:
        'Vineyards classified A-F by the Cadastro system, influencing grape pricing and Port production quotas',
    styleSummary:
        'Source of both fortified Port (Ruby, Tawny, Vintage, LBV, White) and, increasingly, high-quality unfortified Douro red table wines from the same steep, terraced vineyards.',
    mapAssetPath: 'assets/images/maps/douro.png',
  ),
  const RegionProfile(
    id: 'region-barossa',
    name: 'Barossa Valley',
    country: 'Australia',
    primaryModule: WsetModule.d3,
    climate:
        'Warm, Mediterranean-influenced; irrigation supplements naturally low rainfall.',
    soils:
        'Varied — sandy loam over clay in valley floor areas, with some ironstone/quartz in higher sites.',
    keyGrapes: ['Shiraz', 'Grenache', 'Cabernet Sauvignon'],
    appellations: [
      'Barossa Valley GI',
      'Eden Valley GI (higher, cooler, adjacent sub-region)'
    ],
    qualityClassification:
        'Geographical Indication (GI) system — geography-only, no yield/variety restriction',
    styleSummary:
        'Full-bodied, richly fruited, often oak-aged Shiraz from some of the world\'s oldest continuously producing (ungrafted) vines.',
    mapAssetPath: 'assets/images/maps/barossa.png',
  ),
  const RegionProfile(
    id: 'region-marlborough',
    name: 'Marlborough',
    country: 'New Zealand',
    primaryModule: WsetModule.d3,
    climate:
        'Cool, sunny, and dry, with a wide diurnal temperature range that preserves aromatic intensity and acidity.',
    soils: 'Free-draining alluvial gravels and silt loams over gravel.',
    keyGrapes: ['Sauvignon Blanc', 'Pinot Noir', 'Chardonnay'],
    appellations: [
      'Marlborough GI (Wairau Valley, Awatere Valley sub-regions)'
    ],
    qualityClassification: 'Geographical Indication (GI) system',
    styleSummary:
        'Internationally distinctive, intensely aromatic Sauvignon Blanc with pronounced tropical and herbaceous notes; also a growing source of quality Pinot Noir.',
    mapAssetPath: 'assets/images/maps/marlborough.png',
  ),
];
