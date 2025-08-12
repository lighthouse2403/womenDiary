
import 'package:equatable/equatable.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';
import 'package:women_diary/cycle/cycle_model.dart';

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

/// Update cycle
class CreateCycleEvent extends CycleEvent {
  const CreateCycleEvent(this.newCycle);
  final CycleModel newCycle;

  @override
  List<Object?> get props => [newCycle.id];
}

class UpdateCycleEvent extends CycleEvent {
  const UpdateCycleEvent(this.newCycle);
  final CycleModel newCycle;

  @override
  List<Object?> get props => [newCycle.id];
}

/// Delete cycle
class DeleteCycleEvent extends CycleEvent {
  const DeleteCycleEvent(this.id);
  final String id;

  @override
  List<Object?> get props => [id];
}

/// Update cycle information
class UpdateCycleStartTimeEvent extends CycleEvent {
  final DateTime startTime;

  const UpdateCycleStartTimeEvent(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class UpdateCycleEndTimeEvent extends CycleEvent {
  final DateTime startTime;

  const UpdateCycleEndTimeEvent(this.startTime);

  @override
  List<Object?> get props => [startTime];
}

class UpdateCycleNoteEvent extends CycleEvent {
  final String note;

  const UpdateCycleNoteEvent(this.note);

  @override
  List<Object?> get props => [note];
}
