import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_history/new_action.dart';

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
