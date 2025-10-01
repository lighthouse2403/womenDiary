import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:equatable/equatable.dart';

class CycleState extends Equatable {
  const CycleState();
  @override
  List<Object?> get props => [];
}

class LoadedAllCycleState extends CycleState {
  const LoadedAllCycleState(this.cycleList);

  final List<CycleModel> cycleList;
  @override
  List<Object?> get props => [cycleList, DateTime.now().microsecondsSinceEpoch];
}

class LoadedCycleDetailState extends CycleState {
  final CycleModel cycle;
  const LoadedCycleDetailState(this.cycle);

  @override
  List<Object?> get props => [cycle];
}

class LoadedActionsState extends CycleState {
  final List<ActionModel> actions;
  const LoadedActionsState(this.actions);

  @override
  List<Object?> get props => [actions];
}

class CycleSavedSuccessfullyState extends CycleState {
  const CycleSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}
