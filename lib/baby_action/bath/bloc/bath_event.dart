import 'package:baby_diary/baby_action/bath/bath_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BathEvent extends Equatable {
  const BathEvent();
  @override
  List<Object?> get props => [];
}

///-------------------------------- Bath detail --------------------------------
class InitBathDetailEvent extends BathEvent {
  final BathModel bath;
  const InitBathDetailEvent(this.bath);

  @override
  List<Object?> get props => [bath.id];
}

class DeleteBathEvent extends BathEvent {
  const DeleteBathEvent(this.bath);
  final BathModel bath;

  @override
  List<Object?> get props => [bath.id];
}

class SelectBabyEvent extends BathEvent {
  const SelectBabyEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby.babyId];
}

class ChangedStartBathEvent extends BathEvent {
  const ChangedStartBathEvent(this.startTime);
  final DateTime startTime;

  @override
  List<Object?> get props => [startTime];
}

class ChangedStopBathEvent extends BathEvent {
  const ChangedStopBathEvent(this.stopTime);
  final DateTime? stopTime;

  @override
  List<Object?> get props => [stopTime];
}

class ChangedNoteEvent extends BathEvent {
  const ChangedNoteEvent(this.note);
  final String note;

  @override
  List<Object?> get props => [note];
}

class SaveNewBathEvent extends BathEvent {
  const SaveNewBathEvent();

  @override
  List<Object?> get props => [];
}

class UpdateBathEvent extends BathEvent {
  const UpdateBathEvent();

  @override
  List<Object?> get props => [];
}

///-------------------------------- Bath History  ------------------------------
class LoadAllBathHistoryEvent extends BathEvent {
  const LoadAllBathHistoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadBathHistoryByDateEvent extends BathEvent {
  final DateTime time;
  const LoadBathHistoryByDateEvent(this.time);
  @override
  List<Object?> get props => [time];
}
