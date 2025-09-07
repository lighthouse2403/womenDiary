import 'package:equatable/equatable.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class CycleData extends Equatable {
  final int currentDay;
  final int cycleLength;
  final int averageCycleLength;
  final int remainDays;
  final int longestCycle;
  final int shortestCycle;
  final DateTime ovalutionDay;
  final PhaseModel currentPhase;

  final List<PhaseModel> phases;

  const CycleData({
    required this.currentDay,
    required this.cycleLength,
    required this.averageCycleLength,
    required this.ovalutionDay,
    required this.remainDays,
    required this.longestCycle,
    required this.shortestCycle,
    required this.currentPhase,
    required this.phases,
  });

  @override
  List<Object?> get props => [currentDay, cycleLength, averageCycleLength, ovalutionDay, remainDays, longestCycle, shortestCycle, currentPhase, phases];
}

class HomeState extends Equatable {
  final CycleData? cycle;
  final List<ScheduleModel>? schedules;
  final bool isLoadingCycle;
  final bool isLoadingSchedule;

  const HomeState({
    this.cycle,
    this.schedules,
    this.isLoadingCycle = false,
    this.isLoadingSchedule = false,
  });

  HomeState copyWith({
    CycleData? cycle,
    List<ScheduleModel>? schedules,
    bool? isLoadingCycle,
    bool? isLoadingSchedule,
  }) {
    return HomeState(
      cycle: cycle ?? this.cycle,
      schedules: schedules ?? this.schedules,
      isLoadingCycle: isLoadingCycle ?? this.isLoadingCycle,
      isLoadingSchedule: isLoadingSchedule ?? this.isLoadingSchedule,
    );
  }

  ScheduleModel? get nextSchedule =>
      (schedules != null && schedules!.isNotEmpty) ? schedules!.first : null;

  int get currentDay => cycle?.currentDay ?? 0;
  int get cycleLength => cycle?.cycleLength ?? 30;
  DateTime get ovalutionDay => cycle?.ovalutionDay ?? DateTime.now();

  @override
  List<Object?> get props => [cycle, schedules, isLoadingCycle, isLoadingSchedule];
}
