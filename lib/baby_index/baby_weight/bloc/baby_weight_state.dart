import 'package:equatable/equatable.dart';

class BabyWeightState extends Equatable {
  final bool? isSubmitting;

  const BabyWeightState({this.isSubmitting,});

  @override
  List<Object?> get props => [isSubmitting];
}

class StartLoadingState extends BabyWeightState {

  const StartLoadingState();

  @override
  List<Object?> get props => [];
}

class StartEditBabyWeightState extends BabyWeightState {

  const StartEditBabyWeightState();

  @override
  List<Object?> get props => [];
}

class LoadingBabyWeightFailState extends BabyWeightState {

  const LoadingBabyWeightFailState();

  @override
  List<Object?> get props => [];
}

class StartInitBabyWeight extends BabyWeightState {

  const StartInitBabyWeight();

  @override
  List<Object?> get props => [];
}

class InitBabyWeightSuccessful extends BabyWeightState {

  const InitBabyWeightSuccessful();

  @override
  List<Object?> get props => [];
}

class StartLoadingBabyWeightState extends BabyWeightState {

  const StartLoadingBabyWeightState();

  @override
  List<Object?> get props => [];
}

class LoadingBabyWeightSuccessful extends BabyWeightState {
  const LoadingBabyWeightSuccessful();

  @override
  List<Object?> get props => [];
}

class LoadingBabyClothersFail extends BabyWeightState {
  const LoadingBabyClothersFail();

  @override
  List<Object?> get props => [];
}

class StartSavingBabyWeightState extends BabyWeightState {
  const StartSavingBabyWeightState();

  @override
  List<Object?> get props => [];
}

class SaveBabyWeightSuccessfulState extends BabyWeightState {

  const SaveBabyWeightSuccessfulState();

  @override
  List<Object?> get props => [];
}

class SaveBabyWeightFailState extends BabyWeightState {

  const SaveBabyWeightFailState();

  @override
  List<Object?> get props => [];
}

class StartDeleteBabyWeightState extends BabyWeightState {
  const StartDeleteBabyWeightState();

  @override
  List<Object?> get props => [];
}
