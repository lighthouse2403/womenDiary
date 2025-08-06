import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_detail/new_action.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/user_action_model.dart';

class UserActionEvent extends Equatable {
  const UserActionEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserActionEvent extends UserActionEvent {
  const LoadUserActionEvent();

  @override
  List<Object?> get props => [];
}

class UpdateActionTypeEvent extends UserActionEvent {
  final ActionType? actionType;

  const UpdateActionTypeEvent(this.actionType);

  @override
  List<Object?> get props => [actionType];
}

class UpdateDateRangeEvent extends UserActionEvent {
  final DateTime startTime;
  final DateTime endTime;

  const UpdateDateRangeEvent(this.startTime, this.endTime);

  @override
  List<Object?> get props => [startTime, endTime];
}

/// Action detail
class InitActionDetailEvent extends UserActionEvent {
  final UserAction initialAction;

  const InitActionDetailEvent(this.initialAction);

  @override
  List<Object?> get props => [initialAction];
}

class UpdateActionDetailEvent extends UserActionEvent {
  const UpdateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class CreateActionDetailEvent extends UserActionEvent {
  const CreateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class UpdateTimeEvent extends UserActionEvent {
  final DateTime time;

  const UpdateTimeEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class UpdateEmojiEvent extends UserActionEvent {
  final String emoji;

  const UpdateEmojiEvent(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class UpdateTitleEvent extends UserActionEvent {
  final String title;

  const UpdateTitleEvent(this.title);

  @override
  List<Object?> get props => [title];
}

class UpdateNoteEvent extends UserActionEvent {
  final String note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

