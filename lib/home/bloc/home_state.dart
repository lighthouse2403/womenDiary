import 'package:women_diary/period/red_date.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object?> get props => [];
}

class LoadedRedDateState extends HomeState {
  const LoadedRedDateState(this.redDate);
  final List<RedDateModel> redDate;

  @override
  List<Object?> get props => [redDate.length];
}

class LoadedScheduleState extends HomeState {
  const LoadedScheduleState(this.schedules);
  final List<ScheduleModel> schedules;

  @override
  List<Object?> get props => [schedules.length];
}