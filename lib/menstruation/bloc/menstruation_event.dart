
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
  const DeleteMenstruationEvent({required this.id });

  final String id;
  @override
  List<Object?> get props => [id];
}
