import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_diary/new_action.dart';
import 'package:women_diary/actions_diary/user_action_model.dart';

abstract class ActionHistoryState extends Equatable {
  const ActionHistoryState();

  @override
  List<Object?> get props => [];
}

class ActionHistoryInitial extends ActionHistoryState {}

class ActionHistoryLoading extends ActionHistoryState {}

class ActionHistoryLoadedState extends ActionHistoryState {
  final Map<String, List<UserAction>> groupedActions;
  final ActionType currentFilter;

  const ActionHistoryLoadedState({
    required this.groupedActions,
    required this.currentFilter,
  });

  @override
  List<Object?> get props => [groupedActions, currentFilter];
}

class ActionHistoryError extends ActionHistoryState {
  final String message;

  const ActionHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
