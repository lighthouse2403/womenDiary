import 'package:equatable/equatable.dart';
import 'package:women_diary/actions_diary/new_action.dart';


abstract class ActionHistoryEvent extends Equatable {
  const ActionHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadActionsEvent extends ActionHistoryEvent {}

class FilterActions extends ActionHistoryEvent {
  final ActionType filterType;

  const FilterActions(this.filterType);

  @override
  List<Object?> get props => [filterType];
}
