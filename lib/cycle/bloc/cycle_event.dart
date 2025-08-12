
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

class DeleteCycleFromListEvent extends CycleEvent {
  const DeleteCycleFromListEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteCycleDetailEvent extends CycleEvent {
  const DeleteCycleDetailEvent(this.id);
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
