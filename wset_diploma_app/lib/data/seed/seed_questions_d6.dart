import '../../core/constants/wset_modules.dart';
import '../../domain/entities/question.dart';

/// D6 — Independent Research Assignment. Unlike D1-D5, D6 has no
/// closed-book exam; it is assessed as a piece of independent coursework.
/// This seed set therefore focuses on research methodology and academic
/// practice rather than exam-style recall questions.
final List<Question> seedQuestionsD6 = [
  const Question(
    id: 'd6-001',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.sources'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Which of the following is the best example of a primary source for a D6 research assignment on a specific region\'s changing climate?',
    options: [
      'A newspaper article summarising a study',
      'Original meteorological data and interview transcripts you collected from local producers',
      'A general textbook chapter on climate change',
      'A Wikipedia article on the region',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Primary sources are original, first-hand materials — such as raw data you collect yourself, original interviews, or archival documents — whereas textbooks, encyclopaedia entries, and news summaries are secondary sources that interpret or summarise primary material. Strong D6 assignments typically combine credible secondary sources for context with some primary research/analysis.',
    tags: ['research methods', 'primary sources'],
  ),
  const Question(
    id: 'd6-002',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.referencing'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Why does WSET require consistent referencing (e.g. Harvard style) throughout a D6 assignment?',
    options: [
      'To make the word count longer',
      'To allow markers to verify claims, attribute ideas properly, and avoid plagiarism',
      'It is optional and only affects presentation marks',
      'Only direct quotations need referencing',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Consistent referencing lets assessors trace claims back to credible sources, gives proper credit for others\' ideas and data, and is essential to demonstrating academic integrity. Both direct quotations and paraphrased ideas/data drawn from a source must be referenced, not quotations alone.',
    tags: ['referencing', 'academic integrity'],
  ),
  const Question(
    id: 'd6-003',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.question-design'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'A well-designed D6 research question should be:',
    options: [
      'As broad as possible, to allow maximum flexibility',
      'Focused and answerable within the assignment\'s scope and word count, with room for critical analysis',
      'Phrased so it can only be answered "yes" or "no"',
      'Identical to a question already fully answered in the WSET Diploma study guides',
    ],
    correctOptionIndexes: [1],
    explanation:
        'A strong research question is narrow enough to be thoroughly investigated within the assignment\'s word limit, but substantial enough to require genuine analysis and evaluation rather than simple description — and it should go beyond what is already comprehensively covered in the standard Diploma study guides, since D6 assesses independent research skill.',
    tags: ['research question', 'scope'],
  ),
  const Question(
    id: 'd6-004',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.source-evaluation'],
    type: QuestionType.multipleChoice,
    difficulty: 3,
    prompt:
        'When evaluating the credibility of a source for D6, which factors should you consider? (Select all that apply)',
    options: [
      'The author\'s expertise and potential bias',
      'How recently the source was published, relative to your topic',
      'Whether the source is peer-reviewed or from a reputable publisher/organisation',
      'Whether the source agrees with your existing hypothesis',
    ],
    correctOptionIndexes: [0, 1, 2],
    explanation:
        'Credible source evaluation weighs the author\'s expertise/potential conflicts of interest, currency (especially important for fast-changing topics like climate or market data), and the rigour of the publication process (peer review, reputable industry body, established publisher). Deliberately favouring sources purely because they support your existing view introduces confirmation bias and weakens the analysis.',
    tags: ['source evaluation', 'critical analysis'],
  ),
  const Question(
    id: 'd6-005',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.structure'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'A typical structure for a D6 research assignment includes an introduction, main analysis, and:',
    options: [
      'A second, unrelated introduction',
      'A conclusion that draws together findings and directly addresses the research question',
      'A verbatim repeat of the executive summary',
      'No reference list, since this is assessed coursework',
    ],
    correctOptionIndexes: [1],
    explanation:
        'A sound structure moves from introduction (context and research question) through a well-evidenced analysis to a conclusion that synthesises findings and answers the original question directly — plus a full reference list/bibliography, which remains required for assessed academic coursework.',
    tags: ['structure', 'conclusion'],
  ),
  const Question(
    id: 'd6-006',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.analysis'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt:
        'Which best distinguishes "critical analysis" from mere "description" in a D6 assignment?',
    options: [
      'Critical analysis simply restates more facts than description',
      'Critical analysis evaluates evidence, weighs different viewpoints, and draws reasoned conclusions, rather than just recounting information',
      'Description requires more references than analysis',
      'There is no meaningful difference for assessment purposes',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Description recounts what is known ("Region X produces mostly variety Y"); critical analysis goes further, interrogating why, weighing conflicting evidence or viewpoints, assessing significance and limitations, and building a reasoned argument — the skill D6 is specifically designed to assess.',
    tags: ['critical analysis'],
  ),
  const Question(
    id: 'd6-007',
    module: WsetModule.d6,
    topicIds: ['d6.research-methods.plagiarism'],
    type: QuestionType.singleChoice,
    difficulty: 2,
    prompt:
        'Submitting a paraphrased passage from a source without citation, even though it is not a direct quote, is:',
    options: [
      'Acceptable, since it is not a verbatim quotation',
      'Still a form of plagiarism, because the underlying idea/data is not your own and is uncredited',
      'Only a problem if more than one paragraph is paraphrased',
      'Only relevant for the reference list, not the main text',
    ],
    correctOptionIndexes: [1],
    explanation:
        'Plagiarism covers uncredited use of others\' ideas, data, or structure, not just verbatim text — paraphrasing a source\'s argument or findings without attribution still misrepresents whose work it is and must be cited just as a direct quotation would be.',
    tags: ['plagiarism', 'academic integrity'],
  ),
];
