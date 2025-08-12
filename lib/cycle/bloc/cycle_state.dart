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
  List<Object?> get props => [cycleList.length];
}

class CycleSavedSuccessfullyState extends CycleState {
  const CycleSavedSuccessfullyState();

  @override
  List<Object?> get props => [];
}
