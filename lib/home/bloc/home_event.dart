
import 'package:equatable/equatable.dart';

class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object?> get props => [];
}

class LoadCycleEvent extends HomeEvent {
  const LoadCycleEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduleEvent extends HomeEvent {
  LoadScheduleEvent();

  @override
  List<Object?> get props => [];
}

class LoadRedDateEvent extends HomeEvent {
  const LoadRedDateEvent();

  @override
  List<Object?> get props => [];
}

class StartNewCycleEvent extends HomeEvent {
  const StartNewCycleEvent();

  @override
  List<Object?> get props => [];
}

class EndCycleEvent extends HomeEvent {
  const EndCycleEvent();

  @override
  List<Object?> get props => [];
}

class EndMenstruationEvent extends HomeEvent {
  const EndMenstruationEvent();

  @override
  List<Object?> get props => [];
}