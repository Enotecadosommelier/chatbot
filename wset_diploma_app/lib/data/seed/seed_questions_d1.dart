import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D1 — Wine Production. Viticulture, vinification, and the scientific
/// basis of wine composition and tasting.
final List<Question> seedQuestionsD1 = [
  const Question(
    id: 'd1-001',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.climate'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Which climate classification system uses "growing season average temperature" (GST) to categorise wine regions?',
    options: [
      'The Winkler Index',
      'The Huglin Index',
      'The Multicriteria Climate Classification (MCC) System',
      'The Köppen system',
    ],
    correctOptionIndexes: [2],
    explanation:
        'The Multicriteria Climate Classification (MCC) System, developed by Tonietto and Carbonneau, classifies regions using growing season average temperature alongside the Huglin Heliothermal Index, the Cool Night Index, and the Dryness Index. The Winkler Index sums degree-days above 10°C; the Huglin Index is a heat summation index weighted for day length; Köppen is a general climate classification, not wine-specific.',
    tags: ['climate', 'viticulture'],
    references: ['WSET Diploma D1 Study Guide, Unit 1'],
  ),
  const Question(
    id: 'd1-002',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.canopy-management'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'What is the primary purpose of leaf removal in the fruiting zone?',
    options: [
      'To reduce the vine\'s overall yield',
      'To increase sunlight and airflow around the grape bunches',
      'To encourage deeper root growth',
      'To delay budbreak in spring',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Leaf removal (leaf pulling) around the fruiting zone increases sunlight exposure and air circulation around the bunches, which aids ripening, reduces fungal disease pressure (e.g. botrytis bunch rot), and can influence phenolic and aromatic development. It is a canopy management technique, not primarily a yield-reduction or rooting technique.',
    tags: ['canopy management', 'viticulture'],
  ),
  const Question(
    id: 'd1-003',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.fermentation'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'During alcoholic fermentation, which yeast genus is responsible for the vast majority of ethanol production in commercial winemaking?',
    options: ['Brettanomyces', 'Saccharomyces', 'Oenococcus', 'Lactobacillus'],
    correctOptionIndexes: [1],
    explanation:
        'Saccharomyces cerevisiae (and related Saccharomyces species) is the primary yeast responsible for converting sugar into ethanol and carbon dioxide during alcoholic fermentation. Brettanomyces is a spoilage yeast associated with "farmyard" aromas; Oenococcus oeni and Lactobacillus are bacteria involved in malolactic conversion, not alcoholic fermentation.',
    tags: ['fermentation', 'yeast'],
  ),
  const Question(
    id: 'd1-004',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.malolactic'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Malolactic conversion transforms which acid into which other acid?',
    options: [
      'Tartaric acid into malic acid',
      'Malic acid into lactic acid',
      'Citric acid into acetic acid',
      'Lactic acid into tartaric acid',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Malolactic conversion (MLC) is a bacterial process, typically carried out by Oenococcus oeni, that converts the harsher-tasting malic acid into the softer-tasting lactic acid (plus a small amount of CO2). This reduces total acidity and adds buttery/creamy diacetyl notes when encouraged.',
    tags: ['malolactic', 'acidity'],
  ),
  const Question(
    id: 'd1-005',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.red-winemaking'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'What is the main purpose of "punching down" (pigeage) during red wine fermentation?',
    options: [
      'To cool the must down',
      'To submerge the cap of skins and extract colour, tannin, and flavour',
      'To stop fermentation early',
      'To remove lees from the bottom of the tank',
    ],
    correctOptionIndexes: [1],
    explanation:
        'During red fermentation, CO2 pushes solids (skins, seeds) to the surface forming a "cap". Punching down (pigeage) submerges this cap back into the fermenting must, increasing contact between skins and juice to extract colour, tannin, and flavour compounds. Pumping over (remontage) achieves a similar goal by pumping juice from the bottom over the cap.',
    tags: ['red winemaking', 'extraction'],
  ),
  const Question(
    id: 'd1-006',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.oak'],
    type: QuestionType.multipleChoice,
    difficulty: 3,
    prompt:
        'Which of the following are typical flavour/aroma contributions of new oak to wine? (Select all that apply)',
    options: [
      'Vanilla',
      'Toast/smoke',
      'Green bell pepper',
      'Coconut (from American oak)'
    ],
    correctOptionIndexes: [0, 1, 3],
    explanation:
        'New oak can contribute vanilla (from vanillin), toast/smoke (from the toasting of the barrel staves), and coconut notes (particularly associated with American oak, from oak lactones). Green bell pepper aromas come from methoxypyrazines in the grape itself (e.g. under-ripe Cabernet Sauvignon or Sauvignon Blanc), not from oak.',
    tags: ['oak', 'maturation'],
  ),
  const Question(
    id: 'd1-007',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.soil'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Which soil property is generally considered most influential on vine vigour and, indirectly, wine quality?',
    options: [
      'Soil colour',
      'Water availability/drainage',
      'Soil pH alone',
      'The presence of fossils in the soil',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Water availability (governed largely by drainage and water-holding capacity) is widely considered the most influential soil property on vine vigour: soils that impose mild water stress tend to produce smaller berries with a higher skin-to-juice ratio, often associated with higher quality potential. Soil colour and mineral/fossil content have secondary or indirect effects (e.g. heat retention), and there is no scientific consensus that minerals are absorbed and directly tasted in wine.',
    tags: ['soil', 'terroir'],
  ),
  const Question(
    id: 'd1-008',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.sparkling'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'In the traditional method of sparkling wine production, where does the second fermentation take place?',
    options: [
      'In a large pressurised tank',
      'In the bottle in which the wine will be sold',
      'In an open-top fermenter',
      'In the vineyard, before harvest',
    ],
    correctOptionIndexes: [1],
    explanation:
        'In the traditional method (méthode traditionnelle), the second fermentation (prise de mousse) takes place inside the individual bottle in which the wine is ultimately sold, after tirage liqueur (base wine + yeast + sugar) is added. This is distinct from the tank method (Charmat), where the second fermentation occurs in a large pressurised tank before bottling.',
    tags: ['sparkling wine', 'traditional method'],
  ),
  const Question(
    id: 'd1-009',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.fortified'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Fortification involves adding what to a wine or partially fermented must?',
    options: [
      'Sulphur dioxide',
      'A grape spirit (typically around 96% abv)',
      'Additional yeast',
      'Oak chips',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Fortification is the addition of a high-strength grape spirit (typically around 96% abv, sometimes diluted) to a wine or fermenting must, raising the alcohol level and, if added during fermentation, halting fermentation by killing the yeast — leaving residual sugar behind (as in Port).',
    tags: ['fortified wine', 'fortification'],
  ),
  const Question(
    id: 'd1-010',
    module: WsetModule.d1,
    topicIds: ['d1.tasting.acidity'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Which acid is unique to grapes among common wine acids and does not occur widely in other fruits?',
    options: ['Malic acid', 'Citric acid', 'Tartaric acid', 'Lactic acid'],
    correctOptionIndexes: [2],
    explanation:
        'Tartaric acid is the principal acid found in grapes and is relatively unusual in the plant kingdom, giving grapes (and wine) their characteristic acid backbone. Malic and citric acids are common across many fruits; lactic acid is produced during malolactic conversion, not present in grapes themselves.',
    tags: ['acidity', 'tasting'],
  ),
  const Question(
    id: 'd1-011',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.diseases'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Botrytis cinerea, when it develops on ripe, healthy white grapes in favourable humid-then-dry conditions, is known as:',
    options: ['Downy mildew', 'Noble rot', 'Powdery mildew', 'Esca'],
    correctOptionIndexes: [1],
    explanation:
        'When Botrytis cinerea infects ripe, healthy grapes under alternating humid and dry conditions, it can concentrate sugars and add distinctive aromas without ruining the fruit — this beneficial form is called "noble rot" and is essential to sweet wines such as Sauternes and Tokaji Aszú. In unfavourable (wet) conditions, the same fungus causes destructive "grey rot".',
    tags: ['botrytis', 'disease', 'sweet wine'],
  ),
  const Question(
    id: 'd1-012',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.additives'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'What is the main purpose of adding sulphur dioxide (SO2) during winemaking?',
    options: [
      'To increase alcohol level',
      'To act as an antioxidant and antimicrobial agent',
      'To add sweetness',
      'To increase tannin extraction',
    ],
    correctOptionIndexes: [1],
    explanation:
        'SO2 is used throughout winemaking primarily as an antioxidant (protecting against oxidation) and antimicrobial agent (inhibiting unwanted yeasts and bacteria). It has no meaningful effect on alcohol level, sweetness, or tannin extraction.',
    tags: ['sulphur dioxide', 'additives'],
  ),
  const Question(
    id: 'd1-013',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.training'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'Guyot is an example of which type of vine training?',
    options: [
      'Bush/head training with no wires',
      'Cane-pruned, wire-trained system',
      'A method used exclusively for sparkling wine production',
      'A rootstock variety',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Guyot (simple or double) is a cane-pruned, wire-trained system where one or two canes from the previous year\'s growth are tied down to a wire, with a renewal spur left for next year\'s cane. It is widely used in regions such as Bordeaux. It is not a bush-vine system nor a rootstock.',
    tags: ['training system', 'pruning'],
  ),
  const Question(
    id: 'd1-014',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.rose'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'The saignée method of making rosé wine involves:',
    options: [
      'Blending finished red and white wines together',
      'Bleeding off a portion of pink juice from a red must after a short period of skin contact',
      'Pressing black grapes very gently with no skin contact at all',
      'Adding red wine colourant after fermentation',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Saignée ("bleeding") involves drawing off a portion of lightly-coloured juice from a red-wine must after a short maceration period; this juice is then fermented separately as rosé, while the remaining must becomes a more concentrated red wine. Blending red and white to make rosé is prohibited for most still wines in the EU (with historic exceptions such as some rosé Champagne).',
    tags: ['rosé', 'saignée'],
  ),
  const Question(
    id: 'd1-015',
    module: WsetModule.d1,
    topicIds: ['d1.tasting.tannin'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Tannins in wine are primarily extracted from which parts of the grape (and optionally oak)?',
    options: [
      'Pulp and juice only',
      'Skins, seeds, stems, and oak',
      'Yeast cells',
      'Grape leaves',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Tannins are phenolic compounds found mainly in grape skins, seeds, and stems, and can also be contributed by oak during barrel maturation. Grape pulp/juice itself contains negligible tannin, which is why white wines made with minimal skin contact are typically low in tannin.',
    tags: ['tannin', 'phenolics'],
  ),
];
