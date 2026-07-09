import '../../domain/entities/grape_profile.dart';

/// A starter set of major grape profiles. Structured to scale: each new
/// variety is one more const entry with the same shape, and the content
/// pipeline (docs/CONTENT_ROADMAP.md) describes how this grows toward full
/// coverage of the D3 syllabus grape list.
final List<GrapeProfile> kSeedGrapeProfiles = [
  const GrapeProfile(
    id: 'grape-cabernet-sauvignon',
    name: 'Cabernet Sauvignon',
    synonyms: [],
    colour: 'black',
    keyRegions: [
      'Bordeaux (Left Bank)',
      'Napa Valley',
      'Coonawarra',
      'Maipo Valley'
    ],
    viticultureNotes:
        'Late-budding and late-ripening; thick skins and small berries give a high skin-to-juice ratio; buds late enough to avoid spring frost but needs a long, warm growing season to ripen fully.',
    vinificationNotes:
        'High tannin and colour extraction from skins/seeds; commonly oak-matured; often blended with Merlot/Cabernet Franc to soften structure.',
    typicalAromaDescriptors: [
      'Blackcurrant',
      'Cedar',
      'Green bell pepper (if under-ripe)',
      'Graphite',
      'Tobacco (with age)'
    ],
    bodyProfile: 'Full',
    acidityProfile: 'Medium+ to high',
    tanninProfile: 'High',
    imageAssetPath: 'assets/images/grapes/cabernet_sauvignon.png',
  ),
  const GrapeProfile(
    id: 'grape-merlot',
    name: 'Merlot',
    synonyms: [],
    colour: 'black',
    keyRegions: [
      'Bordeaux (Right Bank: Saint-Émilion, Pomerol)',
      'California',
      'Chile'
    ],
    viticultureNotes:
        'Buds and ripens earlier than Cabernet Sauvignon; thinner skins; prone to coulure and botrytis in damp conditions; suits cooler clay/limestone soils on the Right Bank.',
    vinificationNotes:
        'Softer tannins than Cabernet Sauvignon; often oak-aged; can be varietally bottled or form the backbone of Right Bank Bordeaux blends.',
    typicalAromaDescriptors: ['Plum', 'Black cherry', 'Chocolate', 'Bay leaf'],
    bodyProfile: 'Medium to full',
    acidityProfile: 'Medium',
    tanninProfile: 'Medium to medium+',
    imageAssetPath: 'assets/images/grapes/merlot.png',
  ),
  const GrapeProfile(
    id: 'grape-pinot-noir',
    name: 'Pinot Noir',
    synonyms: ['Spätburgunder (Germany)', 'Pinot Nero (Italy)'],
    colour: 'black',
    keyRegions: [
      'Burgundy',
      'Champagne (blending)',
      'Oregon',
      'Central Otago',
      'Sonoma Coast'
    ],
    viticultureNotes:
        'Thin-skinned, tight-bunched, and disease-prone (esp. botrytis); buds early (frost risk) and prefers cooler climates; highly clonally diverse.',
    vinificationNotes:
        'Typically lower tannin extraction; often whole-bunch/whole-cluster fermentation for aromatic complexity; oak used judiciously to avoid overpowering delicate fruit.',
    typicalAromaDescriptors: [
      'Red cherry',
      'Strawberry',
      'Red plum',
      'Forest floor/mushroom (with age)',
      'Violet'
    ],
    bodyProfile: 'Light to medium',
    acidityProfile: 'Medium+ to high',
    tanninProfile: 'Low to medium',
    imageAssetPath: 'assets/images/grapes/pinot_noir.png',
  ),
  const GrapeProfile(
    id: 'grape-syrah',
    name: 'Syrah',
    synonyms: ['Shiraz (Australia and elsewhere)'],
    colour: 'black',
    keyRegions: [
      'Northern Rhône (Hermitage, Côte-Rôtie)',
      'Barossa Valley',
      'Washington State'
    ],
    viticultureNotes:
        'Vigorous; needs a warm site to ripen fully in cooler regions like the Northern Rhône; susceptible to poor fruit set in cool/wet flowering conditions.',
    vinificationNotes:
        'Deep colour and firm tannin; frequently oak-matured; can be co-fermented with a small amount of Viognier in some Northern Rhône appellations for aromatic lift.',
    typicalAromaDescriptors: [
      'Black pepper',
      'Blackberry',
      'Smoked meat',
      'Violet',
      'Bacon fat (Northern Rhône)'
    ],
    bodyProfile: 'Full',
    acidityProfile: 'Medium+',
    tanninProfile: 'High',
    imageAssetPath: 'assets/images/grapes/syrah.png',
  ),
  const GrapeProfile(
    id: 'grape-nebbiolo',
    name: 'Nebbiolo',
    synonyms: ['Spanna', 'Chiavennasca'],
    colour: 'black',
    keyRegions: ['Barolo', 'Barbaresco', 'Valtellina', 'Gattinara'],
    viticultureNotes:
        'Early-budding, late-ripening; needs specific south-facing sites in Piedmont to ripen fully; sensitive to site selection.',
    vinificationNotes:
        'Historically long maceration for high tannin extraction; modern producers vary from traditional long macerations to shorter, more approachable styles.',
    typicalAromaDescriptors: [
      'Rose',
      'Tar',
      'Red cherry',
      'Dried herbs',
      'Truffle (with age)'
    ],
    bodyProfile: 'Full (though often pale in colour)',
    acidityProfile: 'High',
    tanninProfile: 'High',
    imageAssetPath: 'assets/images/grapes/nebbiolo.png',
  ),
  const GrapeProfile(
    id: 'grape-sangiovese',
    name: 'Sangiovese',
    synonyms: [
      'Brunello (Montalcino clone)',
      'Prugnolo Gentile (Montepulciano clone)'
    ],
    colour: 'black',
    keyRegions: [
      'Chianti Classico',
      'Brunello di Montalcino',
      'Vino Nobile di Montepulciano'
    ],
    viticultureNotes:
        'Buds early, ripens late; sensitive to clonal selection and site; performs best on well-drained galestro/clay soils in Tuscany.',
    vinificationNotes:
        'Traditionally aged in large old Slavonian oak botti; modern producers may use smaller French oak (barrique) for a riper, more international style.',
    typicalAromaDescriptors: [
      'Sour red cherry',
      'Dried herb',
      'Leather',
      'Balsamic note'
    ],
    bodyProfile: 'Medium to full',
    acidityProfile: 'High',
    tanninProfile: 'Medium+ to high',
    imageAssetPath: 'assets/images/grapes/sangiovese.png',
  ),
  const GrapeProfile(
    id: 'grape-tempranillo',
    name: 'Tempranillo',
    synonyms: [
      'Tinta Roriz / Aragonez (Portugal)',
      'Cencibel (parts of Spain)'
    ],
    colour: 'black',
    keyRegions: [
      'Rioja',
      'Ribera del Duero',
      'Douro (as a blending component)'
    ],
    viticultureNotes:
        'Buds and ripens relatively early; benefits from high-altitude sites (e.g. Ribera del Duero) to retain acidity in a warm climate.',
    vinificationNotes:
        'Traditionally aged extensively in American oak in Rioja (contributing coconut/vanilla notes), though French oak use has grown among modern producers.',
    typicalAromaDescriptors: [
      'Red plum',
      'Strawberry',
      'Leather',
      'Dill/coconut (American oak)',
      'Tobacco'
    ],
    bodyProfile: 'Medium to full',
    acidityProfile: 'Medium',
    tanninProfile: 'Medium',
    imageAssetPath: 'assets/images/grapes/tempranillo.png',
  ),
  const GrapeProfile(
    id: 'grape-chardonnay',
    name: 'Chardonnay',
    synonyms: [],
    colour: 'white',
    keyRegions: [
      'Burgundy (Chablis, Côte de Beaune)',
      'Champagne (blending)',
      'Napa Valley',
      'Margaret River'
    ],
    viticultureNotes:
        'Buds early (frost risk, e.g. in Chablis); adaptable to a wide range of climates and soils, taking on very different character from cool Chablis to warm California.',
    vinificationNotes:
        'Highly responsive to winemaking choices: malolactic conversion, oak ageing/fermentation, and lees stirring (bâtonnage) can all shape style dramatically.',
    typicalAromaDescriptors: [
      'Green apple (cool climate)',
      'Citrus',
      'Peach/melon (warm climate)',
      'Butter/vanilla (oak + MLC)'
    ],
    bodyProfile: 'Medium to full',
    acidityProfile: 'Medium to high (cool climate) / medium (warm climate)',
    tanninProfile: 'n/a',
    imageAssetPath: 'assets/images/grapes/chardonnay.png',
  ),
  const GrapeProfile(
    id: 'grape-riesling',
    name: 'Riesling',
    synonyms: [],
    colour: 'white',
    keyRegions: ['Mosel', 'Rheingau', 'Alsace', 'Clare Valley', 'Eden Valley'],
    viticultureNotes:
        'Late-ripening, cold-hardy, retains high acidity even at high ripeness; expresses site/soil differences clearly (e.g. slate soils in the Mosel).',
    vinificationNotes:
        'Usually fermented in neutral vessels (steel or old oak) to preserve aromatics; rarely uses new oak or malolactic conversion; wide range of sweetness levels produced from the same variety.',
    typicalAromaDescriptors: [
      'Lime',
      'Green apple',
      'White flowers',
      'Petrol/kerosene (with bottle age)'
    ],
    bodyProfile: 'Light to medium',
    acidityProfile: 'High',
    tanninProfile: 'n/a',
    imageAssetPath: 'assets/images/grapes/riesling.png',
  ),
  const GrapeProfile(
    id: 'grape-sauvignon-blanc',
    name: 'Sauvignon Blanc',
    synonyms: ['Fumé Blanc (some California labelling)'],
    colour: 'white',
    keyRegions: [
      'Loire Valley (Sancerre, Pouilly-Fumé)',
      'Marlborough',
      'Bordeaux (blending with Sémillon)'
    ],
    viticultureNotes:
        'Vigorous, needs canopy management to avoid excess methoxypyrazine (green pepper) character from shaded fruit; buds and ripens relatively early.',
    vinificationNotes:
        'Usually fermented cool in inert vessels to preserve thiols and aromatics; oak use is more the exception (e.g. some white Bordeaux) than the rule.',
    typicalAromaDescriptors: [
      'Gooseberry',
      'Passionfruit (esp. Marlborough)',
      'Blackcurrant leaf',
      'Grapefruit'
    ],
    bodyProfile: 'Light to medium',
    acidityProfile: 'High',
    tanninProfile: 'n/a',
    imageAssetPath: 'assets/images/grapes/sauvignon_blanc.png',
  ),
  const GrapeProfile(
    id: 'grape-chenin-blanc',
    name: 'Chenin Blanc',
    synonyms: ['Steen (South Africa, historically)'],
    colour: 'white',
    keyRegions: [
      'Loire Valley (Vouvray, Savennières)',
      'South Africa (Stellenbosch, Swartland)'
    ],
    viticultureNotes:
        'High natural acidity retained even at high ripeness, enabling everything from bone-dry to lusciously sweet (botrytised) styles from the same variety; susceptible to botrytis, which can be used to advantage.',
    vinificationNotes:
        'Style is heavily winemaker/site-driven: can be made dry, off-dry, sweet, or sparkling (e.g. Crémant de Loire); often minimal oak for fresher expressions.',
    typicalAromaDescriptors: [
      'Quince',
      'Green apple',
      'Honey (sweeter styles)',
      'Wet wool/lanolin'
    ],
    bodyProfile: 'Medium',
    acidityProfile: 'High',
    tanninProfile: 'n/a',
    imageAssetPath: 'assets/images/grapes/chenin_blanc.png',
  ),
];
