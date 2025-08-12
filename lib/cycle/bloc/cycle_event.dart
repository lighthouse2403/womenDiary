
import 'package:equatable/equatable.dart';

class CycleEvent extends Equatable {
  const CycleEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllCycleEvent extends CycleEvent {
  const LoadAllCycleEvent();

  @override
  List<Object?> get props => [];
}

class CreateActionDetailEvent extends CycleEvent {
  const CreateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class DeleteActionFromListEvent extends CycleEvent {
  const DeleteActionFromListEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteActionDetailEvent extends CycleEvent {
  const DeleteActionDetailEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateStartTimeEvent extends CycleEvent {
  final DateTime startTime;

  const UpdateStartTimeEvent(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class UpdateNoteEvent extends CycleEvent {
  final String note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteCycleEvent extends CycleEvent {
  const DeleteCycleEvent({ required this.startTime, required this.endTime });

  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}
