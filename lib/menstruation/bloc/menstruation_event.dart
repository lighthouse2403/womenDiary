
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

class DeleteMenstruationEvent extends MenstruationEvent {
  const DeleteMenstruationEvent({ required this.startTime, required this.endTime });

  final int startTime;
  final int endTime;

  @override
  List<Object?> get props => [startTime, endTime];
}
