import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D3 — Wines of the World. The largest and most content-heavy unit;
/// this seed set samples across France, Italy, Spain, Germany, and the
/// New World rather than attempting exhaustive regional coverage.
final List<Question> seedQuestionsD3 = [
  const Question(
    id: 'd3-001',
    module: WsetModule.d3,
    topicIds: ['d3.france.bordeaux'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'In the Médoc, which grape variety typically dominates the blend on the well-drained gravel soils closest to the Gironde estuary?',
    options: ['Merlot', 'Cabernet Sauvignon', 'Petit Verdot', 'Malbec'],
    correctOptionIndexes: [1],
    explanation:
        'Cabernet Sauvignon thrives on the warm, well-drained gravel soils of the Left Bank (Médoc/Graves), ripening reliably there and forming the backbone of most Left Bank blends alongside Merlot, Cabernet Franc, and small amounts of Petit Verdot. On the Right Bank (Saint-Émilion, Pomerol), cooler clay/limestone soils favour Merlot instead.',
    tags: ['Bordeaux', 'Cabernet Sauvignon'],
  ),
  const Question(
    id: 'd3-002',
    module: WsetModule.d3,
    topicIds: ['d3.france.burgundy'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'In Burgundy\'s classification hierarchy, which tier sits directly below Grand Cru?',
    options: [
      'Village wines',
      'Premier Cru',
      'Regional (Bourgogne) wines',
      'Cru Bourgeois'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Burgundy\'s quality pyramid, from top to bottom, is: Grand Cru → Premier Cru → Village → Regional (e.g. Bourgogne AOC). Cru Bourgeois is an unrelated classification used in the Médoc (Bordeaux), not Burgundy.',
    tags: ['Burgundy', 'classification'],
  ),
  const Question(
    id: 'd3-003',
    module: WsetModule.d3,
    topicIds: ['d3.france.loire'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Sancerre and Pouilly-Fumé, in the eastern Loire Valley, are best known for wines made from which grape?',
    options: [
      'Chenin Blanc',
      'Sauvignon Blanc',
      'Melon de Bourgogne',
      'Chardonnay'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Sancerre and Pouilly-Fumé, on Kimmeridgian clay-limestone and flinty (silex) soils respectively in the eastern Loire, are almost exclusively planted to Sauvignon Blanc, producing benchmark examples of the variety with pronounced aromatic intensity and minerality.',
    tags: ['Loire', 'Sauvignon Blanc'],
  ),
  const Question(
    id: 'd3-004',
    module: WsetModule.d3,
    topicIds: ['d3.germany'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'In the German wine quality pyramid, "Kabinett", "Spätlese", and "Auslese" are ripeness categories within which broader tier?',
    options: ['Landwein', 'Prädikatswein', 'Qualitätswein', 'Deutscher Wein'],
    correctOptionIndexes: [1],
    explanation:
        'Kabinett, Spätlese, Auslese (and above, Beerenauslese, Trockenbeerenauslese, Eiswein) are Prädikat ripeness levels within Prädikatswein, the top tier of German wine law, classified by must weight (grape ripeness at harvest) rather than a geographically narrower designation.',
    tags: ['Germany', 'Prädikatswein', 'Riesling'],
  ),
  const Question(
    id: 'd3-005',
    module: WsetModule.d3,
    topicIds: ['d3.italy.piedmont'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Barolo and Barbaresco DOCGs in Piedmont are both made from which grape variety?',
    options: ['Barbera', 'Sangiovese', 'Nebbiolo', 'Dolcetto'],
    correctOptionIndexes: [2],
    explanation:
        'Barolo and Barbaresco, both DOCGs in the Langhe area of Piedmont, are required to be made from 100% Nebbiolo, a variety known for pale colour but high tannin, high acidity, and aromas of red fruit, tar, and roses. Barbera and Dolcetto are separate, generally lighter-tannin varieties also grown in Piedmont.',
    tags: ['Piedmont', 'Nebbiolo'],
  ),
  const Question(
    id: 'd3-006',
    module: WsetModule.d3,
    topicIds: ['d3.italy.tuscany'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Chianti Classico is required to contain a minimum percentage of which grape variety?',
    options: ['Nebbiolo', 'Sangiovese', 'Montepulciano', 'Primitivo'],
    correctOptionIndexes: [1],
    explanation:
        'Chianti Classico DOCG requires a minimum of 80% Sangiovese, with the remainder typically made up of other approved red varieties (indigenous or international). Sangiovese is Tuscany\'s signature grape, also the base of Brunello di Montalcino (100% Sangiovese, locally called Sangiovese Grosso/Brunello).',
    tags: ['Tuscany', 'Sangiovese', 'Chianti'],
  ),
  const Question(
    id: 'd3-007',
    module: WsetModule.d3,
    topicIds: ['d3.spain.rioja'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'In Rioja\'s ageing classification, a "Reserva" red wine must be aged for a minimum total of how long before release, with at least one year in oak (under current DOCa rules)?',
    options: ['1 year', '2 years', '3 years', '5 years'],
    correctOptionIndexes: [2],
    explanation:
        'Rioja Reserva red wines require a minimum of 3 years total ageing before release, including at least 1 year in oak barrel. This sits between Crianza (minimum 2 years total, at least 1 in oak) and Gran Reserva (minimum 5 years total, at least 2 in oak and 2 in bottle).',
    tags: ['Rioja', 'ageing classification'],
  ),
  const Question(
    id: 'd3-008',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.usa'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'An American Viticultural Area (AVA) designation primarily regulates:',
    options: [
      'Permitted grape varieties and maximum yields',
      'The geographical origin of the grapes, with minimum percentage rules, but not variety or yield',
      'Minimum ageing requirements in oak',
      'Maximum residual sugar levels',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Unlike European appellation systems, an AVA is purely a delimited geographical designation: it does not restrict grape varieties, yields, or winemaking methods. A wine labelled with an AVA name must simply have at least 85% of its grapes grown within that AVA (federal TTB rule).',
    tags: ['AVA', 'USA', 'wine law'],
  ),
  const Question(
    id: 'd3-009',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.australia'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'The Barossa Valley in South Australia is particularly renowned for old-vine plantings of which grape variety?',
    options: ['Pinot Noir', 'Shiraz (Syrah)', 'Riesling', 'Sauvignon Blanc'],
    correctOptionIndexes: [1],
    explanation:
        'The Barossa Valley is world-famous for powerful, full-bodied Shiraz, including some of the oldest continuously producing Shiraz vines in the world (some pre-phylloxera, ungrafted, planted in the 19th century). The neighbouring, cooler Eden Valley is more associated with Riesling.',
    tags: ['Australia', 'Barossa', 'Shiraz'],
  ),
  const Question(
    id: 'd3-010',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.newzealand'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Marlborough, New Zealand\'s largest wine region, built its international reputation primarily on which style?',
    options: [
      'Full-bodied, oaked Chardonnay',
      'Pungent, intensely aromatic Sauvignon Blanc',
      'Sweet fortified wine',
      'Traditional-method sparkling wine only',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Marlborough, at the north of New Zealand\'s South Island, became internationally famous from the 1980s onward for a distinctive, intensely aromatic style of Sauvignon Blanc with pronounced tropical fruit and "green" (herbaceous) notes, driven partly by high sunlight hours and cool nights.',
    tags: ['New Zealand', 'Marlborough', 'Sauvignon Blanc'],
  ),
  const Question(
    id: 'd3-011',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.argentina'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Argentina\'s Mendoza region is most closely associated with which red grape variety?',
    options: ['Tempranillo', 'Malbec', 'Carmenère', 'Zinfandel'],
    correctOptionIndexes: [1],
    explanation:
        'Malbec, originally from South West France, found its most celebrated modern expression in Mendoza\'s high-altitude, desert-like vineyards (aided by irrigation), producing deeply coloured, ripe, velvety-tannin wines that became Argentina\'s signature export style.',
    tags: ['Argentina', 'Mendoza', 'Malbec'],
  ),
  const Question(
    id: 'd3-012',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.chile'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Carmenère, now something of a signature grape for Chile, was originally an important variety in which region?',
    options: [
      'Rioja, Spain',
      'Bordeaux, France',
      'Piedmont, Italy',
      'Mosel, Germany'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Carmenère was historically one of the six red Bordeaux varieties but nearly disappeared after phylloxera devastated European vineyards, as it proved difficult to graft successfully. Vines long misidentified in Chile as Merlot were confirmed in the 1990s to be Carmenère, which has since become closely associated with Chilean wine.',
    tags: ['Chile', 'Carmenère'],
  ),
  const Question(
    id: 'd3-013',
    module: WsetModule.d3,
    topicIds: ['d3.southafrica'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Pinotage, a grape variety strongly associated with South Africa, is a crossing of Pinot Noir and which other variety?',
    options: ['Cinsault', 'Grenache', 'Merlot', 'Syrah'],
    correctOptionIndexes: [0],
    explanation:
        'Pinotage was bred in South Africa in 1925 by Professor Abraham Perold, crossing Pinot Noir with Cinsault (locally then known as "Hermitage"), hence the portmanteau name "Pinotage".',
    tags: ['South Africa', 'Pinotage'],
  ),
  const Question(
    id: 'd3-014',
    module: WsetModule.d3,
    topicIds: ['d3.france.rhone'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'In the Northern Rhône, which single red grape variety is permitted for appellations such as Hermitage and Côte-Rôtie?',
    options: ['Grenache', 'Syrah', 'Mourvèdre', 'Cinsault'],
    correctOptionIndexes: [1],
    explanation:
        'Northern Rhône red appellations (Côte-Rôtie, Hermitage, Crozes-Hermitage, Cornas, Saint-Joseph) are based on Syrah, sometimes co-fermented with a small amount of the white grape Viognier (permitted, though rarely used today, in Côte-Rôtie). This contrasts with the Southern Rhône, where GSM blends (Grenache, Syrah, Mourvèdre) dominate, as in Châteauneuf-du-Pape.',
    tags: ['Rhône', 'Syrah'],
  ),
  const Question(
    id: 'd3-015',
    module: WsetModule.d3,
    topicIds: ['d3.france.alsace'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Alsace is unusual among French regions in that its wine labels typically emphasise:',
    options: [
      'The négociant\'s house name only',
      'The grape variety, alongside the appellation',
      'The vintage only, with no other information',
      'The word "Grand Vin" as a legal quality tier',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Unlike most French AOC regions, Alsace wines are commonly labelled varietally (e.g. Riesling, Gewurztraminer, Pinot Gris) in addition to the Alsace AOC designation — a labelling convention closer to New World practice, reflecting the region\'s historical Germanic influence.',
    tags: ['Alsace', 'labelling'],
  ),
];
