import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class ActionState extends Equatable {
  const ActionState();

  @override
  List<Object?> get props => [];
}

class ActionHistoryInitial extends ActionState {}

class ActionHistoryLoading extends ActionState {}

class ActionTypeUpdatedState extends ActionState {
  final ActionTypeModel? type;
  final List<ActionTypeModel> allType;
  const ActionTypeUpdatedState({required this.type, required this.allType});

  @override
  List<Object?> get props => [type?.id, allType.length];
}

class ActionLoadedState extends ActionState {
  final List<ActionModel> actions;

  const ActionLoadedState({required this.actions,});

  @override
  List<Object?> get props => [actions.map((e) => e.id), DateTime.now()];
}

class CycleDetectedState extends ActionState {
  final CycleModel cycle;

  const CycleDetectedState(this.cycle);

  @override
  List<Object?> get props => [cycle.id];
}

class ActionLoadedErrorState extends ActionState {
  final String message;

  const ActionLoadedErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Action detail
class ActionDetailUpdatedState extends ActionState {
  final ActionModel initialAction;

  const ActionDetailUpdatedState(this.initialAction);

  @override
  List<Object?> get props => [initialAction];
}

class SaveButtonState extends ActionState {
  const SaveButtonState(this.isEnable);

  final bool isEnable;
  @override
  List<Object?> get props => [isEnable];
}

class EmojiUpdatedState extends ActionState {
  final String emoji;

  const EmojiUpdatedState(this.emoji);

  @override
  List<Object?> get props => [emoji];
}

class TitleUpdatedState extends ActionState {
  final String title;

  const TitleUpdatedState(this.title);

  @override
  List<Object?> get props => [title];
}

class TimeUpdatedState extends ActionState {
  final DateTime time;

  const TimeUpdatedState(this.time);

  @override
  List<Object?> get props => [time];
}

class NoteUpdatedState extends ActionState {
  final String note;

  const NoteUpdatedState(this.note);

  @override
  List<Object?> get props => [note];
}

class ActionSavedSuccessfullyState extends ActionState {
  const ActionSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}

class ActionDeletedState extends ActionState {
  const ActionDeletedState();

  @override
  List<Object?> get props => [];
}