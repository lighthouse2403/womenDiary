import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_action/eating/eating_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class EatingEvent extends Equatable {

  const EatingEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// Eating history
class LoadEatingHistoryByDateEvent extends EatingEvent {
  final DateTime time;
  const LoadEatingHistoryByDateEvent(this.time);

  @override
  List<Object?> get props => [time];
}

class LoadAllEatingHistoryEvent extends EatingEvent {
  const LoadAllEatingHistoryEvent();

  @override
  List<Object?> get props => [];
}

///-------------------------------- Eating detail ------------------------------
class InitEatingDetailEvent extends EatingEvent {
  final BabyActionModel? eating;
  const InitEatingDetailEvent(this.eating);

  @override
  List<Object?> get props => [eating];
}

class DeleteEatingEvent extends EatingEvent {
  const DeleteEatingEvent();
  @override
  List<Object?> get props => [];
}

class ChangedBabyEvent extends EatingEvent {
  const ChangedBabyEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby];
}

class ChangedQuantityEvent extends EatingEvent {
  const ChangedQuantityEvent(this.quantity);
  final int quantity;

  @override
  List<Object?> get props => [quantity];
}

class ChangedDurationEvent extends EatingEvent {
  const ChangedDurationEvent(this.duration);
  final int duration;

  @override
  List<Object?> get props => [duration];
}

class ChangedNoteEvent extends EatingEvent {
  const ChangedNoteEvent(this.note);
  final String note;

  @override
  List<Object?> get props => [note];
}

class ChangedUnitEvent extends EatingEvent {
  const ChangedUnitEvent(this.unit);
  final String unit;

  @override
  List<Object?> get props => [unit];
}

class ChangedStartTimeEvent extends EatingEvent {
  const ChangedStartTimeEvent(this.startTime);
  final DateTime startTime;

  @override
  List<Object?> get props => [startTime];
}

class ChangedStopTimeEvent extends EatingEvent {
  const ChangedStopTimeEvent(this.stopTime);
  final DateTime stopTime;

  @override
  List<Object?> get props => [stopTime];
}

class UpdateEatingEvent extends EatingEvent {
  const UpdateEatingEvent();

  @override
  List<Object?> get props => [];
}

class CreateNewEatingEvent extends EatingEvent {
  const CreateNewEatingEvent();

  @override
  List<Object?> get props => [];
}
