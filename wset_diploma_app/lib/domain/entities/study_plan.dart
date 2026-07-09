import '../../core/constants/wset_modules.dart';

class StudySession {
  final DateTime date;
  final WsetModule module;
  final String focusTopicId;
  final Duration plannedDuration;
  final bool completed;

  const StudySession({
    required this.date,
    required this.module,
    required this.focusTopicId,
    required this.plannedDuration,
    this.completed = false,
  });

  StudySession copyWith({bool? completed}) => StudySession(
        date: date,
        module: module,
        focusTopicId: focusTopicId,
        plannedDuration: plannedDuration,
        completed: completed ?? this.completed,
      );
}

/// A generated countdown-to-exam schedule spreading due topics and weak
/// areas across the days remaining before [examDate].
class StudyPlan {
  final DateTime examDate;
  final WsetModule targetModule;
  final List<StudySession> sessions;

  const StudyPlan({
    required this.examDate,
    required this.targetModule,
    required this.sessions,
  });

  int get daysRemaining =>
      examDate.difference(DateTime.now()).inDays.clamp(0, 100000);

  double get completionRatio {
    if (sessions.isEmpty) return 0;
    return sessions.where((s) => s.completed).length / sessions.length;
  }
}
