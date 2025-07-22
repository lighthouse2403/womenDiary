import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/period/period_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class LoadedCycleState extends HomeState {
  final List<PeriodModel> periodList;
  final int currentDay;
  final int cycleLength;
  final List<PhaseModel> phases;
  final PhaseModel currentPhase;
  final PhaseModel nextPhase;
  final int daysUntilNext;

  const LoadedCycleState({
    required this.currentDay,
    required this.cycleLength,
    required this.phases,
    required this.currentPhase,
    required this.nextPhase,
    required this.daysUntilNext,
    required this.periodList
  });

  @override
  List<Object?> get props => [currentDay, cycleLength, phases, currentPhase, nextPhase, daysUntilNext, periodList.length];
}

class LoadedScheduleState extends HomeState {
  const LoadedScheduleState(this.schedules);
  final List<ScheduleModel> schedules;

  @override
  List<Object?> get props => [schedules.length];
}
