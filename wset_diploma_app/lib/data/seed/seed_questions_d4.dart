import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D4 — Sparkling Wines. Production methods, regions, and labelling terms.
final List<Question> seedQuestionsD4 = [
  const Question(
    id: 'd4-001',
    module: WsetModule.d4,
    topicIds: ['d4.production.traditional-method'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'What is "tirage liqueur"?',
    options: [
      'The final dosage added before corking',
      'A mixture of base wine, yeast, and sugar added to trigger the second fermentation in bottle',
      'The clear wine drawn off after disgorgement',
      'A sweet liqueur added to Champagne cocktails',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Tirage liqueur (liqueur de tirage) is the mixture of base wine, a measured amount of sugar, and a selected yeast strain added to still base wine before bottling, triggering the second fermentation (prise de mousse) that produces the wine\'s CO2 and pressure in the traditional method.',
    tags: ['traditional method', 'tirage'],
  ),
  const Question(
    id: 'd4-002',
    module: WsetModule.d4,
    topicIds: ['d4.production.lees'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Extended lees ageing in traditional-method sparkling wine typically contributes which character?',
    options: [
      'Green bell pepper and grassy aromas',
      'Biscuit, brioche, and toasty autolytic aromas',
      'Intense primary fruit with no secondary character',
      'A significant increase in residual sugar',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Autolysis — the breakdown of dead yeast cells (lees) over extended ageing — releases compounds that contribute characteristic biscuit, brioche, toast, and sometimes nutty aromas, prized in premium traditional-method sparkling wines such as vintage Champagne. It does not raise residual sugar (that comes from dosage) and is unrelated to methoxypyrazine-driven green/grassy aromas.',
    tags: ['autolysis', 'lees ageing'],
  ),
  const Question(
    id: 'd4-003',
    module: WsetModule.d4,
    topicIds: ['d4.production.dosage'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'A Champagne labelled "Brut Nature" (or "Brut Zero") has:',
    options: [
      'Between 32 and 50 g/L residual sugar',
      '0-3 g/L residual sugar with no dosage sugar added',
      'A minimum of 12 g/L added sugar',
      'No CO2 pressure at all',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Brut Nature (or Brut Zero) indicates 0-3 g/L residual sugar with no sugar added in the dosage. The sweetness scale continues upward through Extra Brut, Brut, Extra Dry, Sec, Demi-Sec, to Doux (the sweetest, 50+ g/L).',
    tags: ['dosage', 'sweetness levels'],
  ),
  const Question(
    id: 'd4-004',
    module: WsetModule.d4,
    topicIds: ['d4.regions.champagne'],
    type: QuestionType.multipleChoice,
    difficulty: 3,
    prompt:
        'Which three grape varieties dominate plantings in Champagne? (Select all that apply)',
    options: ['Chardonnay', 'Pinot Noir', 'Pinot Meunier', 'Sauvignon Blanc'],
    correctOptionIndexes: [0, 1, 2],
    explanation:
        'Champagne\'s plantings are overwhelmingly Chardonnay, Pinot Noir, and Pinot Meunier (a small amount of other historic varieties such as Pinot Blanc, Pinot Gris, and Arbane are also permitted but negligible in volume). Sauvignon Blanc is not a permitted Champagne variety.',
    tags: ['Champagne', 'grape varieties'],
  ),
  const Question(
    id: 'd4-005',
    module: WsetModule.d4,
    topicIds: ['d4.production.tank-method'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Prosecco (Glera-based sparkling wine from Italy\'s Veneto/Friuli) is typically made using which method?',
    options: [
      'Traditional method',
      'Tank method (Charmat/Martinotti)',
      'Ancestral method',
      'Transfer method'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Prosecco DOC/DOCG is typically produced using the tank method (Charmat, called "Metodo Martinotti" in Italy), where the second fermentation takes place in a large sealed pressurised tank rather than in individual bottles, preserving fresh, primary fruit character and lowering production cost versus the traditional method.',
    tags: ['Prosecco', 'tank method'],
  ),
  const Question(
    id: 'd4-006',
    module: WsetModule.d4,
    topicIds: ['d4.production.ancestral-method'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'The ancestral method (méthode ancestrale) used to make Pét-Nat wines differs from the traditional method chiefly because:',
    options: [
      'It involves two separate fermentations, with tirage liqueur added for the second',
      'The wine is bottled before the single, original fermentation has finished, so it completes in bottle with no disgorgement in the classic style',
      'It always uses only Chardonnay',
      'It requires longer lees ageing than the traditional method',
    ],
    correctOptionIndexes: [1],
    explanation:
        'In the ancestral method, the base wine is bottled while the original (first and only) fermentation is still in progress, so it finishes in bottle, trapping CO2 — there is no second fermentation, no tirage liqueur addition, and classic Pét-Nat is typically released without disgorgement (often cloudy, sur lie).',
    tags: ['ancestral method', 'Pét-Nat'],
  ),
  const Question(
    id: 'd4-007',
    module: WsetModule.d4,
    topicIds: ['d4.regions.cava'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Cava, Spain\'s traditional-method sparkling wine, is produced predominantly (though not exclusively) in which region?',
    options: ['Rioja', 'Penedès, Catalonia', 'Galicia', 'Andalucía'],
    correctOptionIndexes: [1],
    explanation:
        'Although Cava is a geographically dispersed DO (with production zones scattered across parts of Spain), the great majority of Cava is produced in Penedès, Catalonia, historically using indigenous varieties such as Macabeo, Xarel-lo, and Parellada.',
    tags: ['Cava', 'Spain'],
  ),
  const Question(
    id: 'd4-008',
    module: WsetModule.d4,
    topicIds: ['d4.production.disgorgement'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'What is the purpose of disgorgement (dégorgement) in traditional-method production?',
    options: [
      'To add the tirage liqueur',
      'To remove the frozen plug of sediment collected in the neck of the bottle after riddling',
      'To blend base wines from different vintages',
      'To filter the wine before the first fermentation',
    ],
    correctOptionIndexes: [1],
    explanation:
        'After riddling (remuage) collects sediment in the neck of the inverted bottle, disgorgement removes that sediment — commonly by freezing the neck and ejecting the frozen plug under the wine\'s own pressure — leaving a clear wine ready for dosage and final corking.',
    tags: ['disgorgement', 'riddling'],
  ),
  const Question(
    id: 'd4-009',
    module: WsetModule.d4,
    topicIds: ['d4.regions.englishsparkling'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'English sparkling wine production (notably in Sussex and Kent) has grown in part due to:',
    options: [
      'Volcanic soils identical to Etna',
      'Chalk soils similar to Champagne and a cool climate suited to high-acid base wines',
      'A tropical climate ideal for very ripe grapes',
      'A ban on Chardonnay and Pinot Noir plantings',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Parts of southern England share chalk geology with Champagne, and the cool climate helps retain the high acidity that suits traditional-method sparkling wine production; warming trends have also made ripening Chardonnay, Pinot Noir, and Pinot Meunier more consistently viable.',
    tags: ['English sparkling wine'],
  ),
  const Question(
    id: 'd4-010',
    module: WsetModule.d4,
    topicIds: ['d4.regions.franciacorta'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Franciacorta DOCG, in Lombardy, Italy, is unusual among Italian sparkling wines because it:',
    options: [
      'Is made using the tank method exclusively',
      'Is made using the traditional method, with minimum lees-ageing requirements stricter than Champagne\'s general minimum',
      'Cannot legally use Chardonnay',
      'Is a fortified sparkling wine',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Franciacorta is produced by the traditional method and its production rules mandate minimum lees-ageing periods (e.g. at least 18 months for non-vintage, longer for Riserva) that are notably strict — in some categories exceeding Champagne\'s general non-vintage minimum — reflecting its positioning as a premium, quality-focused traditional-method wine.',
    tags: ['Franciacorta', 'Italy'],
  ),
];
