
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BabyEvent extends Equatable {

  const BabyEvent();

  @override
  List<Object?> get props => [];
}

/// Babies
class LoadAllBabyEvent extends BabyEvent {
  const LoadAllBabyEvent();

  @override
  List<Object?> get props => [];
}

/// Baby detail
class InitBabyDetailEvent extends BabyEvent {
  const InitBabyDetailEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby];
}

class DeleteBabyEvent extends BabyEvent {
  final BabyModel baby;
  const DeleteBabyEvent(this.baby);

  @override
  List<Object?> get props => [baby];
}

class SelectedBabyEvent extends BabyEvent {
  const SelectedBabyEvent(this.newBaby);
  final BabyModel newBaby;

  @override
  List<Object?> get props => [newBaby];
}

/// Update property of baby
class UpdatedDobEvent extends BabyEvent {
  final DateTime dob;
  const UpdatedDobEvent(this.dob);

  @override
  List<Object?> get props => [dob];
}

class UpdatedNameEvent extends BabyEvent {
  final String name;
  const UpdatedNameEvent(this.name);

  @override
  List<Object?> get props => [name];
}

class UpdatedGenderEvent extends BabyEvent {
  final Gender gender;
  const UpdatedGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

class SaveBabyDetailEvent extends BabyEvent {
  const SaveBabyDetailEvent();

  @override
  List<Object?> get props => [];
}


