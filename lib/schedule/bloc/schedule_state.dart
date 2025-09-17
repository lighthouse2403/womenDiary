import 'package:equatable/equatable.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class ScheduleState extends Equatable {
  const ScheduleState();

  @override
  List<Object?> get props => [];
}

class ScheduleLoadedState extends ScheduleState {
  const ScheduleLoadedState(this.scheduleList);

  final List<ScheduleModel> scheduleList;
  @override
  List<Object?> get props => [DateTime.now()];
}

/// Action detail
class InitScheduleDetailState extends ScheduleState {
  final ScheduleModel initialSchedule;

  const InitScheduleDetailState(this.initialSchedule);

  @override
  List<Object?> get props => [initialSchedule];
}

class SaveButtonState extends ScheduleState {
  const SaveButtonState(this.isEnable);

  final bool isEnable;
  @override
  List<Object?> get props => [isEnable];
}

class TitleUpdatedState extends ScheduleState {
  final String title;

  const TitleUpdatedState(this.title);

  @override
  List<Object?> get props => [title];
}

class TimeUpdatedState extends ScheduleState {
  final DateTime time;

  const TimeUpdatedState(this.time);

  @override
  List<Object?> get props => [time];
}

class NoteUpdatedState extends ScheduleState {
  final String note;

  const NoteUpdatedState(this.note);

  @override
  List<Object?> get props => [note];
}

class ReminderUpdatedState extends ScheduleState {
  final bool isReminderOn ;
  const ReminderUpdatedState(this.isReminderOn);

  @override
  List<Object?> get props => [isReminderOn];
}

class ScheduleSavedSuccessfullyState extends ScheduleState {
  const ScheduleSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}