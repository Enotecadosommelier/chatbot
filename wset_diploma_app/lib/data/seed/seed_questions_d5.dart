import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D5 — Fortified Wines. Sherry, Port, Madeira, and other fortified styles.
final List<Question> seedQuestionsD5 = [
  const Question(
    id: 'd5-001',
    module: WsetModule.d5,
    topicIds: ['d5.sherry.flor'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: '"Flor" in Sherry production refers to:',
    options: [
      'A layer of yeast that forms on the surface of certain base wines, protecting them from oxidation and imparting distinctive character',
      'A blending technique for mixing multiple vintages',
      'A type of oak barrel used only for Oloroso',
      'The floral aroma compound found in all Sherry styles',
    ],
    correctOptionIndexes: [0],
    explanation:
        'Flor is a film of specific yeast strains (mainly Saccharomyces) that grows on the surface of certain Sherry base wines in partially filled butts, protecting the wine from oxygen and producing biologically-aged styles such as Fino and Manzanilla. Wines that do not sustain flor (or are fortified to a level that prevents it) age oxidatively, becoming styles like Oloroso.',
    tags: ['Sherry', 'flor', 'biological ageing'],
  ),
  const Question(
    id: 'd5-002',
    module: WsetModule.d5,
    topicIds: ['d5.sherry.solera'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'The solera system used for most Sherry is best described as:',
    options: [
      'A single-vintage ageing method with no blending',
      'A fractional blending system where younger wine is progressively blended into and takes on character from a sequence of older wine',
      'A method exclusive to sweet Pedro Ximénez wines',
      'A cold stabilisation technique',
    ],
    correctOptionIndexes: [1],
    explanation:
        'The solera system is a fractional blending process using a series of criaderas (younger scales) and a final solera (oldest scale). A portion is drawn from the oldest butts for bottling, which is then replenished from the next-youngest scale, and so on — meaning bottled Sherry is a blend of many vintages, and no bottling is a single-vintage wine (aside from rare "añada" wines).',
    tags: ['Sherry', 'solera'],
  ),
  const Question(
    id: 'd5-003',
    module: WsetModule.d5,
    topicIds: ['d5.sherry.styles'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Which Sherry style is aged entirely biologically under flor, without ever transitioning to oxidative ageing?',
    options: ['Oloroso', 'Amontillado', 'Fino', 'Pedro Ximénez'],
    correctOptionIndexes: [2],
    explanation:
        'Fino (and Manzanilla, its counterpart matured in Sanlúcar de Barrameda) is aged entirely under a protective layer of flor for its whole maturation, giving pale colour and a fresh, tangy, yeasty character. Amontillado begins under flor but continues oxidatively once the flor dies or is allowed to die; Oloroso is fortified to a level that prevents flor from developing at all, ageing purely oxidatively; Pedro Ximénez is a lusciously sweet style made from sun-dried grapes.',
    tags: ['Sherry', 'Fino'],
  ),
  const Question(
    id: 'd5-004',
    module: WsetModule.d5,
    topicIds: ['d5.port.styles'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'Vintage Port is:',
    options: [
      'Declared every year by every shipper',
      'Made only in years a shipper "declares" as of sufficiently high quality, bottled young, and intended for long bottle ageing',
      'Always aged for at least 20 years in barrel before release',
      'A blend of many different vintages',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Vintage Port is produced only from grapes of a single, exceptional year that a shipper chooses to "declare"; it is bottled after around 2 years in barrel/vat (largely unfiltered) and is intended to age — often for decades — in bottle, developing sediment/deposit that requires decanting. It contrasts with Tawny/Ruby styles, which are blends across vintages and age primarily in wood.',
    tags: ['Port', 'Vintage Port'],
  ),
  const Question(
    id: 'd5-005',
    module: WsetModule.d5,
    topicIds: ['d5.port.production'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'At what stage of production is grape spirit added to make Port?',
    options: [
      'After fermentation is fully complete',
      'During fermentation, before all the sugar has converted to alcohol, to halt fermentation and retain residual sugar',
      'Before fermentation begins, to the fresh must',
      'Only after several years of barrel ageing',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Port is fortified partway through fermentation (once around half the sugar or so has converted), which kills the yeast and halts fermentation, preserving substantial residual sugar alongside the elevated alcohol from the added spirit. This is different from Sherry, which is normally fermented fully dry before fortification.',
    tags: ['Port', 'fortification'],
  ),
  const Question(
    id: 'd5-006',
    module: WsetModule.d5,
    topicIds: ['d5.port.styles'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Late Bottled Vintage (LBV) Port comes from a single vintage and is typically bottled after how long in barrel?',
    options: ['2 years', '4-6 years', '10-12 years', '20+ years'],
    correctOptionIndexes: [1],
    explanation:
        'LBV Port comes from a single (though not "declared") vintage and is aged in barrel for around 4-6 years before bottling — longer than Vintage Port\'s roughly 2 years — which makes it approachable sooner and, if filtered, generally without significant sediment.',
    tags: ['Port', 'LBV'],
  ),
  const Question(
    id: 'd5-007',
    module: WsetModule.d5,
    topicIds: ['d5.madeira.production'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'The distinctive "maderised" (deliberately oxidised/heated) character of Madeira comes from a process called:',
    options: [
      'Solera',
      'Estufagem (or the slower canteiro method)',
      'Saignée',
      'Chaptalisation'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Madeira is deliberately heated and oxidised, either via estufagem (accelerated heating in tanks or rooms, used for commercial-grade wines) or the slower, more prestigious canteiro method (natural ageing in warm lodges over years). This unique process makes Madeira exceptionally stable and resistant to oxidation once opened.',
    tags: ['Madeira', 'estufagem'],
  ),
  const Question(
    id: 'd5-008',
    module: WsetModule.d5,
    topicIds: ['d5.madeira.grapes'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Which of these Madeira grape varieties typically produces the driest style of wine?',
    options: ['Malmsey (Malvasia)', 'Bual', 'Verdelho', 'Sercial'],
    correctOptionIndexes: [3],
    explanation:
        'Sercial produces the driest, highest-acid style of Madeira, typically grown at higher, cooler altitudes. The traditional sweetness order from driest to sweetest is Sercial → Verdelho → Bual → Malmsey (Malvasia), though modern Madeira labelling increasingly also uses sweetness terms directly (Dry, Medium Dry, Medium Rich, Rich).',
    tags: ['Madeira', 'Sercial'],
  ),
  const Question(
    id: 'd5-009',
    module: WsetModule.d5,
    topicIds: ['d5.other-fortified'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'A Vin Doux Naturel (VDN) such as Muscat de Beaumes-de-Venise is produced by:',
    options: [
      'Fortifying a fully fermented dry wine with neutral spirit',
      'Fortifying partway through fermentation (mutage), similarly in principle to Port, to retain natural grape sugar',
      'Adding concentrated grape must after fermentation to sweeten a dry wine',
      'Allowing full spontaneous oxidation with no added spirit at all',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Vins Doux Naturels are fortified partway through fermentation (mutage), stopping fermentation and preserving natural residual sugar from the grape — conceptually similar to Port\'s production, though French VDN rules and permitted grape varieties (e.g. Muscat, Grenache) differ. This is distinct from simply back-sweetening a finished dry wine.',
    tags: ['Vin Doux Naturel', 'fortified wine'],
  ),
  const Question(
    id: 'd5-010',
    module: WsetModule.d5,
    topicIds: ['d5.sherry.styles'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Pedro Ximénez (PX) Sherry\'s intense sweetness and dark colour primarily result from:',
    options: [
      'Extended biological ageing under flor',
      'Sun-drying (soleo) the grapes after harvest to concentrate sugars before pressing',
      'Adding cane sugar after fermentation',
      'Blending with red wine',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Pedro Ximénez grapes are traditionally laid out on mats in the sun after harvest (soleo) to partially raisin and concentrate their sugars before pressing, producing an intensely sweet, dark, thick wine, further deepened in colour and complexity through extended oxidative ageing.',
    tags: ['Sherry', 'Pedro Ximénez', 'sun-drying'],
  ),
];
