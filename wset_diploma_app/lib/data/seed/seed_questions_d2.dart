import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D2 — Wine Business. Global trade, distribution, marketing, and law.
final List<Question> seedQuestionsD2 = [
  const Question(
    id: 'd2-001',
    module: WsetModule.d2,
    topicIds: ['d2.trade.incoterms'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Under the Incoterm "DDP" (Delivered Duty Paid), who is responsible for import duties?',
    options: [
      'The buyer',
      'The seller',
      'The freight forwarder only',
      'The customs authority absorbs the cost'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Under DDP, the seller bears maximum responsibility, delivering goods to the buyer\'s destination with all export/import duties, taxes, and customs formalities already paid. This is the opposite end of the Incoterms spectrum from EXW (Ex Works), where the buyer takes on nearly all responsibility from the seller\'s premises onward.',
    tags: ['incoterms', 'trade'],
  ),
  const Question(
    id: 'd2-002',
    module: WsetModule.d2,
    topicIds: ['d2.distribution'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'In a traditional three-tier distribution system, which tier sits between producer and retailer?',
    options: [
      'Importer/wholesaler',
      'Consumer',
      'Regulator',
      'Négociant-éleveur'
    ],
    correctOptionIndexes: [0],
    explanation:
        'The classic three-tier system runs producer → importer/wholesaler/distributor → retailer (on- or off-trade) → consumer. The importer/wholesaler tier typically handles logistics, warehousing, compliance, and building a route to market for producers who cannot sell direct.',
    tags: ['distribution', 'route to market'],
  ),
  const Question(
    id: 'd2-003',
    module: WsetModule.d2,
    topicIds: ['d2.marketing'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'The "4 Ps" of the marketing mix are Product, Price, Place, and:',
    options: ['Profit', 'Promotion', 'People', 'Packaging'],
    correctOptionIndexes: [1],
    explanation:
        'The classic marketing mix framework consists of Product, Price, Place, and Promotion. Some extended models add People, Process, and Physical evidence (the "7 Ps"), but the foundational "4 Ps" ends with Promotion.',
    tags: ['marketing mix'],
  ),
  const Question(
    id: 'd2-004',
    module: WsetModule.d2,
    topicIds: ['d2.law.labelling'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Under EU wine law, a Protected Designation of Origin (PDO) wine must:',
    options: [
      'Be made from grapes grown anywhere in the EU',
      'Be produced entirely from grapes grown within the defined geographical area and comply with that area\'s production rules',
      'Contain no added sulphites',
      'Be bottled only in glass bottles under 750ml',
    ],
    correctOptionIndexes: [1],
    explanation:
        'A PDO (the EU-wide equivalent of terms like AOC/AOP in France or DOC/DOCG in Italy) requires that grapes are grown, and the wine produced, within a defined geographical area, following that area\'s specific rules on permitted varieties, yields, winemaking methods, and often minimum quality standards. PGI (Protected Geographical Indication) is a broader, less restrictive tier below PDO.',
    tags: ['wine law', 'PDO'],
  ),
  const Question(
    id: 'd2-005',
    module: WsetModule.d2,
    topicIds: ['d2.business-structures'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'A négociant in Burgundy typically:',
    options: [
      'Only grows grapes and never buys from other growers',
      'Buys grapes, must, or wine from growers and vinifies/blends/matures/bottles it under their own label',
      'Is a government regulatory body',
      'Only handles the export paperwork for growers',
    ],
    correctOptionIndexes: [1],
    explanation:
        'A négociant (négociant-éleveur) purchases grapes, must, or finished wine from growers, and may vinify, blend, mature (élevage), bottle, and market it under their own brand — a common structure in fragmented regions like Burgundy where many growers farm very small plots.',
    tags: ['négociant', 'business structure'],
  ),
  const Question(
    id: 'd2-006',
    module: WsetModule.d2,
    topicIds: ['d2.finance'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'Gross margin is best described as:',
    options: [
      'Revenue minus cost of goods sold, expressed as a value or percentage of revenue',
      'Total revenue before any costs are deducted',
      'Net profit after tax',
      'The retail price minus the recommended retail price',
    ],
    correctOptionIndexes: [0],
    explanation:
        'Gross margin = Revenue − Cost of Goods Sold (COGS), often expressed as a percentage of revenue. It reflects profitability before overheads, marketing, and other operating expenses are deducted — distinct from net margin/net profit, which accounts for all costs.',
    tags: ['finance', 'margin'],
  ),
  const Question(
    id: 'd2-007',
    module: WsetModule.d2,
    topicIds: ['d2.sustainability'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Which certification specifically requires that no synthetic chemical fertilisers, pesticides, or herbicides are used in the vineyard?',
    options: [
      'Sustainable certification (general)',
      'Organic certification',
      'Fair Trade certification',
      'ISO 9001'
    ],
    correctOptionIndexes: [1],
    explanation:
        'Organic certification (e.g. EU Organic, USDA Organic) specifically prohibits synthetic fertilisers, pesticides, and herbicides in the vineyard. General "sustainable" schemes often address a broader mix of environmental, social, and economic criteria without banning all synthetic inputs outright; Fair Trade focuses on social/economic equity; ISO 9001 is a quality-management standard unrelated to farming inputs.',
    tags: ['organic', 'sustainability'],
  ),
  const Question(
    id: 'd2-008',
    module: WsetModule.d2,
    topicIds: ['d2.trade.tariffs'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'An import tariff on wine is best described as:',
    options: [
      'A tax levied by the exporting country on wine leaving its borders',
      'A tax or duty levied by the importing country on wine entering its market',
      'A discount offered by producers to large-volume buyers',
      'A voluntary certification fee',
    ],
    correctOptionIndexes: [1],
    explanation:
        'An import tariff is a tax imposed by the destination (importing) country\'s government on goods entering its market, which raises the landed cost of imported wine and can affect competitiveness versus domestically produced wine.',
    tags: ['tariffs', 'trade'],
  ),
  const Question(
    id: 'd2-009',
    module: WsetModule.d2,
    topicIds: ['d2.marketing.branding'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'A "premiumisation" strategy in the wine business generally refers to:',
    options: [
      'Reducing prices across the board to increase volume',
      'Shifting a brand or portfolio toward higher price points/perceived quality',
      'Removing a product from the market entirely',
      'Selling only through discount retailers',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Premiumisation describes a strategic shift toward higher price tiers and perceived quality/prestige — often via improved packaging, provenance storytelling, limited releases, or moving consumers up a portfolio\'s price ladder — rather than competing purely on volume and price.',
    tags: ['branding', 'strategy'],
  ),
  const Question(
    id: 'd2-010',
    module: WsetModule.d2,
    topicIds: ['d2.law.labelling'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Which of these is a mandatory element on most wine labels sold in the EU?',
    options: [
      'Tasting notes',
      'Actual alcoholic strength by volume (abv)',
      'Serving temperature suggestion',
      'Food pairing suggestions'
    ],
    correctOptionIndexes: [1],
    explanation:
        'EU labelling rules require mandatory information including actual alcoholic strength (abv), the name/address of the bottler, country of origin, net volume, allergen information (e.g. "contains sulphites"), and a lot number, among others. Tasting notes, serving temperature, and food pairings are optional marketing additions.',
    tags: ['labelling', 'law'],
  ),
  const Question(
    id: 'd2-011',
    module: WsetModule.d2,
    topicIds: ['d2.trade.channels'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt: 'The "on-trade" refers to which sales channel?',
    options: [
      'Supermarkets and off-licences where wine is bought to consume elsewhere',
      'Restaurants, bars, and hotels where wine is bought and consumed on the premises',
      'Direct-to-consumer online sales only',
      'Wine sold exclusively at the cellar door',
    ],
    correctOptionIndexes: [1],
    explanation:
        'The on-trade covers venues where wine is sold and consumed on-site — restaurants, bars, hotels — as opposed to the off-trade (retail, supermarkets, online) where wine is purchased for consumption elsewhere.',
    tags: ['on-trade', 'off-trade'],
  ),
  const Question(
    id: 'd2-012',
    module: WsetModule.d2,
    topicIds: ['d2.trade.forex'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'If a wine is priced in euros and the euro strengthens significantly against the importer\'s home currency, what is the likely effect on the importer\'s landed cost?',
    options: [
      'The landed cost decreases',
      'The landed cost increases',
      'There is no effect on landed cost',
      'The effect depends only on the vintage',
    ],
    correctOptionIndexes: [1],
    explanation:
        'If the invoice currency (euros) strengthens relative to the importer\'s home currency, the importer needs more of their home currency to buy the same amount of euros, increasing the landed cost — a key foreign-exchange risk in the international wine trade, often mitigated through hedging.',
    tags: ['foreign exchange', 'trade'],
  ),
];
