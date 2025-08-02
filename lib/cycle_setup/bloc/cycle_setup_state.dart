import 'package:equatable/equatable.dart';

class CycleSetupState extends Equatable {
  CycleSetupState();
  @override
  List<Object?> get props => [];
}

class UpdatedCycleLengthState extends CycleSetupState {
  UpdatedCycleLengthState(this.cycleLength);

  final int cycleLength;
  @override
  List<Object?> get props => [];
}

class UpdatedMenstruationLengthState extends CycleSetupState {
  UpdatedMenstruationLengthState(this.menstruationLength);

  final int menstruationLength;
  @override
  List<Object?> get props => [];
}

class UpdatedSubmitState extends CycleSetupState {
  UpdatedSubmitState(this.isEnable);
  final isEnable;
  @override
  List<Object?> get props => [];
}

class SavedCycleInformationState extends CycleSetupState {
  SavedCycleInformationState();
  @override
  List<Object?> get props => [];
}
