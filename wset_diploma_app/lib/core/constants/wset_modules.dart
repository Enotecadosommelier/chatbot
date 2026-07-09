/// The six units of the WSET Level 4 Diploma in Wines, as examined by the
/// Wine & Spirit Education Trust. Kept as a single source of truth so every
/// feature (quiz filters, mock exams, study planner, statistics) references
/// the same module list and exam-weighting metadata.
enum WsetModule {
  d1,
  d2,
  d3,
  d4,
  d5,
  d6,
}

class WsetModuleInfo {
  final WsetModule module;
  final String code;
  final String title;
  final String assessmentFormat;
  final Duration typicalExamDuration;

  const WsetModuleInfo({
    required this.module,
    required this.code,
    required this.title,
    required this.assessmentFormat,
    required this.typicalExamDuration,
  });
}

const Map<WsetModule, WsetModuleInfo> kWsetModules = {
  WsetModule.d1: WsetModuleInfo(
    module: WsetModule.d1,
    code: 'D1',
    title: 'Wine Production',
    assessmentFormat: 'Closed-book exam: 50 multiple choice questions',
    typicalExamDuration: Duration(minutes: 60),
  ),
  WsetModule.d2: WsetModuleInfo(
    module: WsetModule.d2,
    code: 'D2',
    title: 'Wine Business',
    assessmentFormat: 'Closed-book exam: short answer + essay questions',
    typicalExamDuration: Duration(hours: 2, minutes: 15),
  ),
  WsetModule.d3: WsetModuleInfo(
    module: WsetModule.d3,
    code: 'D3',
    title: 'Wines of the World',
    assessmentFormat:
        'Theory (essay, 3h) + blind tasting of 12 wines using the SAT (2h15)',
    typicalExamDuration: Duration(hours: 5, minutes: 15),
  ),
  WsetModule.d4: WsetModuleInfo(
    module: WsetModule.d4,
    code: 'D4',
    title: 'Sparkling Wines',
    assessmentFormat:
        'Theory (essay, 1h30) + blind tasting of 2 sparkling wines using the SAT (30m)',
    typicalExamDuration: Duration(hours: 2),
  ),
  WsetModule.d5: WsetModuleInfo(
    module: WsetModule.d5,
    code: 'D5',
    title: 'Fortified Wines',
    assessmentFormat:
        'Theory (essay, 1h30) + blind tasting of 2 fortified wines using the SAT (30m)',
    typicalExamDuration: Duration(hours: 2),
  ),
  WsetModule.d6: WsetModuleInfo(
    module: WsetModule.d6,
    code: 'D6',
    title: 'Independent Research Assignment',
    assessmentFormat: 'Independent research project (coursework, no exam)',
    typicalExamDuration: Duration.zero,
  ),
};

extension WsetModuleX on WsetModule {
  WsetModuleInfo get info => kWsetModules[this]!;
}
