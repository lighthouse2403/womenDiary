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
