import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_action/drinking_milk/bottle_milk/bottle_milk_list/bottle_milk_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BottleMilkEvent extends Equatable {
  const BottleMilkEvent();
  @override
  List<Object?> get props => [];
}

///-------------------------------- Bottle detail --------------------------------
class InitBottleMilkDetailEvent extends BottleMilkEvent {
  final BabyActionModel bottleMilk;
  const InitBottleMilkDetailEvent(this.bottleMilk);

  @override
  List<Object?> get props => [bottleMilk.id];
}

class DeleteBottleMilkEvent extends BottleMilkEvent {
  const DeleteBottleMilkEvent(this.bottleMilk);
  final BottleMilkModel bottleMilk;

  @override
  List<Object?> get props => [bottleMilk.id];
}

class ChangeBabyEvent extends BottleMilkEvent {
  const ChangeBabyEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby.babyId];
}

class ChangedBottleMilkStartTimeEvent extends BottleMilkEvent {
  const ChangedBottleMilkStartTimeEvent(this.startTime);
  final DateTime startTime;

  @override
  List<Object?> get props => [startTime];
}

class ChangedBottleMilkStopTimeEvent extends BottleMilkEvent {
  const ChangedBottleMilkStopTimeEvent(this.stopTime);
  final DateTime stopTime;

  @override
  List<Object?> get props => [stopTime];
}

class ChangedNoteEvent extends BottleMilkEvent {
  const ChangedNoteEvent(this.note);
  final String note;

  @override
  List<Object?> get props => [note];
}

class SaveNewBottleMilkEvent extends BottleMilkEvent {
  const SaveNewBottleMilkEvent();

  @override
  List<Object?> get props => [];
}

class UpdateBottleMilkEvent extends BottleMilkEvent {
  const UpdateBottleMilkEvent();

  @override
  List<Object?> get props => [];
}

///-------------------------------- Bottle History  ------------------------------
class LoadAllBottleMilkHistoryEvent extends BottleMilkEvent {
  const LoadAllBottleMilkHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadBottleMilkHistoryByDateEvent extends BottleMilkEvent {
  final DateTime time;
  const LoadBottleMilkHistoryByDateEvent(this.time);
  @override
  List<Object?> get props => [time];
}
