import 'package:equatable/equatable.dart';

class DoctorState extends Equatable {
  final bool? isSubmitting;

  const DoctorState({this.isSubmitting,});
  @override
  List<Object?> get props => [isSubmitting];
}

class LoadingState extends DoctorState {
  const LoadingState();
  @override
  List<Object?> get props => [];
}

class LoadingSuccessfulState extends DoctorState {
  const LoadingSuccessfulState();
  @override
  List<Object?> get props => [];
}

class LoadingFailState extends DoctorState {

  const LoadingFailState();
  @override
  List<Object?> get props => [];
}

class UpdateRatingSuccessfulState extends DoctorState {

  const UpdateRatingSuccessfulState();
  @override
  List<Object?> get props => [];
}

class UpdateRatingFailState extends DoctorState {

  const UpdateRatingFailState();
  @override
  List<Object?> get props => [];
}

class UpdateNumberOfViewSuccessfulState extends DoctorState {

  const UpdateNumberOfViewSuccessfulState();
  @override
  List<Object?> get props => [];
}

class UpdateNumberOfViewFailState extends DoctorState {

  const UpdateNumberOfViewFailState();
  @override
  List<Object?> get props => [];
}
