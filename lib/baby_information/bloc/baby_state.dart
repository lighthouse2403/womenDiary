
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class BabyState extends Equatable {
  const BabyState();

  @override
  List<Object?> get props => [];
}

/// Babies
class LoadedBabiesState extends BabyState {
  const LoadedBabiesState(this.babies);
  final List<BabyModel> babies;
  @override
  List<Object?> get props => [babies.map((e) => e.babyId)];
}

/// Baby detail
class SavedBabySuccessfulState extends BabyState {
  const SavedBabySuccessfulState();

  @override
  List<Object?> get props => [];
}

class AddedBabyDetailState extends BabyState {
  const AddedBabyDetailState(this.baby);
  final BabyModel? baby;
  @override
  List<Object?> get props => [baby];
}

class UpdatedGenderState extends BabyState {
  const UpdatedGenderState(this.gender);
  final Gender gender;
  @override
  List<Object?> get props => [gender];
}

class UpdatedDobState extends BabyState {
  const UpdatedDobState(this.dob);
  final DateTime dob;
  @override
  List<Object?> get props => [dob];
}