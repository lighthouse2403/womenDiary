import 'package:baby_diary/baby_action/eating/eating_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/common/base/bloc/base_state.dart';
import 'package:equatable/equatable.dart';

class EatingState extends Equatable {

  const EatingState();

  @override
  List<Object?> get props => [];
}

class UpdatedEatingStartTimeState extends EatingState {
  const UpdatedEatingStartTimeState();
  @override
  List<Object?> get props => [];
}

class UpdatedEatingDetailState extends EatingState {
  const UpdatedEatingDetailState(this.eating);
  final EatingModel eating;
  @override
  List<Object?> get props => [eating.id];
}

class ChangedBabyState extends EatingState {
  const ChangedBabyState(this.selectedBaby);
  final BabyModel selectedBaby;
  @override
  List<Object?> get props => [selectedBaby.babyId];
}

class ChangedEatingQuantityState extends EatingState {
  const ChangedEatingQuantityState(this.quantity);
  final int quantity;
  @override
  List<Object?> get props => [quantity];
}

class ChangedEatingStartTimeState extends EatingState {
  const ChangedEatingStartTimeState(this.startTime);
  final DateTime startTime;
  @override
  List<Object?> get props => [startTime];
}

class ChangedEatingStopTimeState extends EatingState {
  const ChangedEatingStopTimeState(this.stopTime);
  final DateTime stopTime;
  @override
  List<Object?> get props => [stopTime];
}

class SaveEatingSuccessfulState extends EatingState {
  const SaveEatingSuccessfulState();

  @override
  List<Object?> get props => [];
}

class DeleteEatingSuccessfulState extends EatingState {
  const DeleteEatingSuccessfulState();

  @override
  List<Object?> get props => [];
}
