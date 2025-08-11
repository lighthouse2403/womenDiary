
import 'package:equatable/equatable.dart';

class MenstruationEvent extends Equatable {
  const MenstruationEvent();
  @override
  List<Object?> get props => [];
}

class LoadAllMenstruationEvent extends MenstruationEvent {
  const LoadAllMenstruationEvent();

  @override
  List<Object?> get props => [];
}

class CreateActionDetailEvent extends MenstruationEvent {
  const CreateActionDetailEvent();

  @override
  List<Object?> get props => [];
}

class DeleteActionFromListEvent extends MenstruationEvent {
  const DeleteActionFromListEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class DeleteActionDetailEvent extends MenstruationEvent {
  const DeleteActionDetailEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

class UpdateStartTimeEvent extends MenstruationEvent {
  final DateTime startTime;

  const UpdateStartTimeEvent(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class UpdateNoteEvent extends MenstruationEvent {
  final String note;

  const UpdateNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}

class DeleteMenstruationEvent extends MenstruationEvent {
  const DeleteMenstruationEvent({ required this.startTime, required this.endTime });

  final DateTime startTime;
  final DateTime endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}
