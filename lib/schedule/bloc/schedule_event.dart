import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleEvent extends ScheduleEvent {
  const LoadScheduleEvent();

  @override
  List<Object?> get props => [];
}

class UpdateDateRangeEvent extends ScheduleEvent {
  final DateTime startTime;
  final DateTime endTime;

  const UpdateDateRangeEvent(this.startTime, this.endTime);

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Action detail
class InitScheduleDetailEvent extends ScheduleEvent {
  final ScheduleModel initialSchedule;

  const InitScheduleDetailEvent(this.initialSchedule);

  @override
  List<Object?> get props => [initialSchedule];
}

class UpdateScheduleDetailEvent extends ScheduleEvent {
  const UpdateScheduleDetailEvent();

  @override
  List<Object?> get props => [];
}

class CreateScheduleDetailEvent extends ScheduleEvent {
  const CreateScheduleDetailEvent();

  @override
  List<Object?> get props => [];
}

class DeleteScheduleFromListEvent extends ScheduleEvent {
  const DeleteScheduleFromListEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteScheduleDetailEvent extends ScheduleEvent {
  const DeleteScheduleDetailEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateTimeEvent extends ScheduleEvent {
  final DateTime time;

  const UpdateTimeEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class UpdateTitleEvent extends ScheduleEvent {
  final String title;

  const UpdateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateNoteEvent extends ScheduleEvent {
  final String note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

