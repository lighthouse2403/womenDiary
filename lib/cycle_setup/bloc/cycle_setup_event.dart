
import 'package:equatable/equatable.dart';

class CycleSetupEvent extends Equatable {
  const CycleSetupEvent();
  @override
  List<Object?> get props => [];
}

class CycleLengthChangedEvent extends CycleSetupEvent {
  const CycleLengthChangedEvent(this.cycleLength);
  final int cycleLength;
  @override
  List<Object?> get props => [cycleLength];
}

class MenstruationLengthChangedEvent extends CycleSetupEvent {
  const MenstruationLengthChangedEvent(this.menstruationLength);
  final int menstruationLength;
  @override
  List<Object?> get props => [menstruationLength];
}

class SubmitCycleInformationEvent extends CycleSetupEvent {
  const SubmitCycleInformationEvent();
  @override
  List<Object?> get props => [];
}
