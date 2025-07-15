import 'package:equatable/equatable.dart';

class VaccinationState extends Equatable {
  final bool? isSubmitting;
  const VaccinationState({this.isSubmitting,});

  @override
  List<Object?> get props => [isSubmitting];
}

class LoadingVaccinationState extends VaccinationState {

  const LoadingVaccinationState();
  @override
  List<Object?> get props => [];
}

class LoadingVaccinationSuccessfulState extends VaccinationState {

  const LoadingVaccinationSuccessfulState();
  @override
  List<Object?> get props => [];
}

class LoadingVaccinationFailState extends VaccinationState {

  const LoadingVaccinationFailState();
  @override
  List<Object?> get props => [];
}

class UpdateVaccinationRatingSuccessfulState extends VaccinationState {
  const UpdateVaccinationRatingSuccessfulState();

  @override
  List<Object?> get props => [];
}

class UpdateVaccinationRatingFailState extends VaccinationState {
  const UpdateVaccinationRatingFailState();
  @override
  List<Object?> get props => [];
}

class UpdateVaccinationNumberOfViewSuccessfulState extends VaccinationState {
  const UpdateVaccinationNumberOfViewSuccessfulState();
  @override
  List<Object?> get props => [];
}

class UpdateVaccinationNumberOfViewFailState extends VaccinationState {
  const UpdateVaccinationNumberOfViewFailState();
  @override
  List<Object?> get props => [];
}
