import 'package:baby_diary/baby_action/drinking_milk/bottle_milk/bottle_milk_list/bottle_milk_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BottleMilkState extends Equatable {

  const BottleMilkState();

  @override
  List<Object?> get props => [];
}

class StopCountBottleTimeState extends BottleMilkState {
  const StopCountBottleTimeState();
  @override
  List<Object?> get props => [];
}

class UpdatedBottleMilkDetailState extends BottleMilkState {
  const UpdatedBottleMilkDetailState(this.bottleMilk);
  final BottleMilkModel bottleMilk;
  @override
  List<Object?> get props => [bottleMilk.id];
}

class ChangedBabyState extends BottleMilkState {
  const ChangedBabyState(this.selectedBaby);
  final BabyModel selectedBaby;
  @override
  List<Object?> get props => [selectedBaby.babyId];
}

class ChangedBottleStartTimeState extends BottleMilkState {
  const ChangedBottleStartTimeState(this.startTime);
  final DateTime startTime;
  @override
  List<Object?> get props => [startTime];
}

class ChangedBottleStopTimeState extends BottleMilkState {
  const ChangedBottleStopTimeState(this.stopTime);
  final DateTime stopTime;
  @override
  List<Object?> get props => [stopTime];
}

class SaveBottleMilkSuccessfulState extends BottleMilkState {
  const SaveBottleMilkSuccessfulState();

  @override
  List<Object?> get props => [];
}

class DeleteBottleMilkSuccessfulState extends BottleMilkState {
  const DeleteBottleMilkSuccessfulState();

  @override
  List<Object?> get props => [];
}
