
import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadCycleEvent extends HomeEvent {
  final int currentDay;
  final int cycleLength;

  const LoadCycleEvent({required this.currentDay, required this.cycleLength});

  @override
  List<Object?> get props => [];
}
