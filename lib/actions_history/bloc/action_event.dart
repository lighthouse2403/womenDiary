import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/action_model.dart';

class ActionEvent extends Equatable {
  const ActionEvent();

  @override
  List<Object?> get props => [];
}

class LoadActionEvent extends ActionEvent {
  const LoadActionEvent();

  @override
  List<Object?> get props => [];
}

class UpdateActionTypeEvent extends ActionEvent {
  final ActionType? actionType;

  const UpdateActionTypeEvent(this.actionType);

  @override
  List<Object?> get props => [actionType];
}

class UpdateDateRangeEvent extends ActionEvent {
  final DateTime startTime;
  final DateTime endTime;

  const UpdateDateRangeEvent(this.startTime, this.endTime);

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Action detail
class InitActionDetailEvent extends ActionEvent {
  final ActionModel initialAction;

  const InitActionDetailEvent(this.initialAction);

  @override
  List<Object?> get props => [initialAction];
}

class UpdateActionDetailEvent extends ActionEvent {
  const UpdateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class CreateActionDetailEvent extends ActionEvent {
  const CreateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class DeleteActionFromListEvent extends ActionEvent {
  const DeleteActionFromListEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteActionDetailEvent extends ActionEvent {
  const DeleteActionDetailEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateTimeEvent extends ActionEvent {
  final DateTime time;

  const UpdateTimeEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class UpdateEmojiEvent extends ActionEvent {
  final String emoji;

  const UpdateEmojiEvent(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class UpdateTitleEvent extends ActionEvent {
  final String title;

  const UpdateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateNoteEvent extends ActionEvent {
  final String note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

