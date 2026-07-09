import '../../core/constants/wset_modules.dart';
import '../../domain/entities/flashcard.dart';

final List<Flashcard> seedFlashcards = [
  const Flashcard(
    id: 'fc-d1-001',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.climate'],
    front: 'What does the Huglin Index measure?',
    back:
        'A heliothermal (heat + sunshine) index used to classify a region\'s climate suitability for ripening particular grape varieties, weighting temperature by day length.',
  ),
  const Flashcard(
    id: 'fc-d1-002',
    module: WsetModule.d1,
    topicIds: ['d1.vinification.fermentation'],
    front:
        'What temperature range is typical for white wine fermentation vs. red wine fermentation?',
    back:
        'White wines are usually fermented cooler (around 12-22°C) to preserve delicate aromatics; reds are usually fermented warmer (around 20-32°C) to aid extraction of colour and tannin.',
  ),
  const Flashcard(
    id: 'fc-d1-003',
    module: WsetModule.d1,
    topicIds: ['d1.viticulture.phylloxera'],
    front: 'Why are most Vitis vinifera vines today grafted onto rootstock?',
    back:
        'To provide resistance to phylloxera, a root-feeding aphid that devastated European vineyards in the late 19th century; American Vitis species rootstocks are naturally resistant.',
  ),
  const Flashcard(
    id: 'fc-d1-004',
    module: WsetModule.d1,
    topicIds: ['d1.tasting.alcohol'],
    front: 'What gives wine its perception of "body" and warmth on the palate?',
    back:
        'Alcohol is a major contributor to perceived body/weight and warmth; glycerol and residual sugar also contribute, but alcohol is the dominant factor.',
  ),
  const Flashcard(
    id: 'fc-d2-001',
    module: WsetModule.d2,
    topicIds: ['d2.trade.incoterms'],
    front: 'What does "EXW" (Ex Works) mean as an Incoterm?',
    back:
        'The seller makes goods available at their own premises; the buyer bears all costs and risks of transport, export/import duties, and insurance from that point onward.',
  ),
  const Flashcard(
    id: 'fc-d2-002',
    module: WsetModule.d2,
    topicIds: ['d2.marketing'],
    front: 'What is "SWOT analysis" used for in a wine business plan?',
    back:
        'A strategic planning tool assessing Strengths, Weaknesses, Opportunities, and Threats to inform business decisions.',
  ),
  const Flashcard(
    id: 'fc-d3-001',
    module: WsetModule.d3,
    topicIds: ['d3.france.burgundy'],
    front:
        'What are the two grape varieties permitted in red and white Burgundy AOC wines (broadly)?',
    back:
        'Pinot Noir for red/rosé Burgundy; Chardonnay for white Burgundy (small exceptions like Aligoté and Gamay exist in specific appellations).',
  ),
  const Flashcard(
    id: 'fc-d3-002',
    module: WsetModule.d3,
    topicIds: ['d3.spain.sherry-region'],
    front: 'What three towns form the "Sherry Triangle"?',
    back:
        'Jerez de la Frontera, Sanlúcar de Barrameda, and El Puerto de Santa María, in Andalucía, Spain.',
  ),
  const Flashcard(
    id: 'fc-d3-003',
    module: WsetModule.d3,
    topicIds: ['d3.germany.riesling'],
    front: 'What makes German Riesling distinctive stylistically?',
    back:
        'Typically high natural acidity balanced against a range of sweetness levels, low-to-moderate alcohol, and pronounced varietal aromatics (citrus, stone fruit, and petrol-like notes with bottle age).',
  ),
  const Flashcard(
    id: 'fc-d3-004',
    module: WsetModule.d3,
    topicIds: ['d3.newworld.usa.california'],
    front: 'What is an AVA?',
    back:
        'American Viticultural Area — a legally defined grape-growing region in the USA, regulating geographical origin only (not variety, yield, or method).',
  ),
  const Flashcard(
    id: 'fc-d4-001',
    module: WsetModule.d4,
    topicIds: ['d4.production.traditional-method'],
    front:
        'Put these traditional-method steps in order: disgorgement, tirage, riddling, dosage.',
    back: 'Tirage → riddling (remuage) → disgorgement → dosage.',
  ),
  const Flashcard(
    id: 'fc-d4-002',
    module: WsetModule.d4,
    topicIds: ['d4.production.dosage'],
    front:
        'Order these Champagne sweetness levels from driest to sweetest: Brut, Extra Dry, Extra Brut, Doux, Sec, Demi-Sec, Brut Nature.',
    back:
        'Brut Nature → Extra Brut → Brut → Extra Dry → Sec → Demi-Sec → Doux.',
  ),
  const Flashcard(
    id: 'fc-d5-001',
    module: WsetModule.d5,
    topicIds: ['d5.sherry.styles'],
    front:
        'Order these Sherry styles from lightest/driest to richest/sweetest (broadly): Oloroso, Fino, Pedro Ximénez, Amontillado.',
    back:
        'Fino → Amontillado → Oloroso → Pedro Ximénez (PX is the sweetest, darkest style).',
  ),
  const Flashcard(
    id: 'fc-d5-002',
    module: WsetModule.d5,
    topicIds: ['d5.port.styles'],
    front:
        'What is the key production difference between Ruby/Tawny/Vintage Port and Sherry?',
    back:
        'Port is fortified partway through fermentation, retaining residual sugar; most Sherry is fully fermented to dryness before fortification.',
  ),
];
