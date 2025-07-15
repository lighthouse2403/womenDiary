import 'package:baby_diary/baby_action/bath/bath_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BathState extends Equatable {
  const BathState();
  @override
  List<Object?> get props => [];
}

class StopCountBathTimeState extends BathState {
  const StopCountBathTimeState();
  @override
  List<Object?> get props => [];
}

class UpdatedBathDetailState extends BathState {
  const UpdatedBathDetailState(this.bathDetail);
  final BathModel bathDetail;
  @override
  List<Object?> get props => [bathDetail.id];
}

class ChangedBabyState extends BathState {
  const ChangedBabyState(this.selectedBaby);
  final BabyModel selectedBaby;
  @override
  List<Object?> get props => [selectedBaby.babyId];
}

class ChangedBathStartTimeState extends BathState {
  const ChangedBathStartTimeState(this.startTime);
  final DateTime startTime;
  @override
  List<Object?> get props => [startTime];
}

class ChangedBathStopTimeState extends BathState {
  const ChangedBathStopTimeState(this.stopTime);
  final DateTime stopTime;
  @override
  List<Object?> get props => [stopTime];
}

class SaveBathSuccessfulState extends BathState {
  const SaveBathSuccessfulState();

  @override
  List<Object?> get props => [];
}

class DeleteBathSuccessfulState extends BathState {
  const DeleteBathSuccessfulState();

  @override
  List<Object?> get props => [];
}
