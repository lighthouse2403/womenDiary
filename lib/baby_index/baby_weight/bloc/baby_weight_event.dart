import 'package:baby_diary/baby_index/index_model.dart';
import 'package:equatable/equatable.dart';

abstract class BabyWeightEvent extends Equatable {
  const BabyWeightEvent();
}

class LoadBabyWeightEvent extends BabyWeightEvent {
  const LoadBabyWeightEvent();

  @override
  List<Object?> get props => [];
}

class SaveBabyWeightEvent extends BabyWeightEvent {
  const SaveBabyWeightEvent();

  @override
  List<Object?> get props => [];
}

class EditBabyBabyWeightEvent extends BabyWeightEvent {
  const EditBabyBabyWeightEvent();

  @override
  List<Object?> get props => [];
}

class DeleteBabyWeightEvent extends BabyWeightEvent {
  const DeleteBabyWeightEvent(this.babyWeightId);
  final String babyWeightId;

  @override
  List<Object?> get props => [babyWeightId];
}

class InitBabyWeightEvent extends BabyWeightEvent {
  const InitBabyWeightEvent(this.babyWeight);
  final IndexModel babyWeight;

  @override
  List<Object?> get props => [babyWeight];
}

class EditWeightEvent extends BabyWeightEvent {
  const EditWeightEvent(this.weight);
  final int weight;

  @override
  List<Object?> get props => [weight];
}

class EditTimeEvent extends BabyWeightEvent {
  const EditTimeEvent(this.newTime);
  final DateTime newTime;

  @override
  List<Object?> get props => [newTime];
}
