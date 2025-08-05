import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/new_action.dart';
import 'package:women_diary/actions_history/user_action_model.dart';

abstract class UserActionState extends Equatable {
  const UserActionState();

  @override
  List<Object?> get props => [];
}

class ActionHistoryInitial extends UserActionState {}

class ActionHistoryLoading extends UserActionState {}

class ActionTypeUpdatedState extends UserActionState {
  final ActionType? type;

  const ActionTypeUpdatedState({required this.type});

  @override
  List<Object?> get props => [type];
}

class UserActionLoadedState extends UserActionState {
  final List<UserAction> actions;

  const UserActionLoadedState({required this.actions,});

  @override
  List<Object?> get props => [actions.length];
}

class UserActionLoadedErrorState extends UserActionState {
  final String message;

  const UserActionLoadedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action detail
class ActionDetailUpdatedState extends UserActionState {
  final UserAction initialAction;

  const ActionDetailUpdatedState(this.initialAction);

  @override
  List<Object?> get props => [initialAction];
}

class EmojiUpdatedState extends UserActionState {
  final String emoji;

  const EmojiUpdatedState(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class TitleUpdatedState extends UserActionState {
  final String title;

  const TitleUpdatedState(this.title);

  @override
  List<Object?> get props => [title];
}

class TimeUpdatedState extends UserActionState {
  final DateTime time;

  const TimeUpdatedState(this.time);

  @override
  List<Object?> get props => [time];
}

class NoteUpdatedState extends UserActionState {
  final String note;

  const NoteUpdatedState(this.note);

  @override
  List<Object?> get props => [note];
}