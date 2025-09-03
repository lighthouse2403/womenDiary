import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class LoadedCycleState extends HomeState {
  final List<CycleModel> periodList;
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

extension CycleStateX on HomeState {
  int get currentDay =>
      this is LoadedCycleState ? (this as LoadedCycleState).currentDay : 0;
  int get cycleLength =>
      this is LoadedCycleState ? (this as LoadedCycleState).cycleLength : 30;
  int get daysUntilNext =>
      this is LoadedCycleState ? (this as LoadedCycleState).daysUntilNext : 30;
  List<PhaseModel> get phases =>
      this is LoadedCycleState ? (this as LoadedCycleState).phases : [];
  ScheduleModel? get nextSchedule =>
      this is LoadedScheduleState ? (this as LoadedScheduleState).schedules.first : null;
}