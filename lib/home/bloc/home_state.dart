import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/schedule/schedule_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class LoadedSelectedBabyState extends HomeState {
  const LoadedSelectedBabyState(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [];
}

class LoadedBabyActionState extends HomeState {
  const LoadedBabyActionState(this.actions);
  final List<BabyActionModel> actions;

  @override
  List<Object?> get props => [actions.length];
}

class LoadedScheduleState extends HomeState {
  const LoadedScheduleState(this.schedules);
  final List<ScheduleModel> schedules;

  @override
  List<Object?> get props => [schedules.length];
}