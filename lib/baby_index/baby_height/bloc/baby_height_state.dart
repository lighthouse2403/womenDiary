import 'package:equatable/equatable.dart';

class BabyHeightState extends Equatable {
  const BabyHeightState();
  @override
  List<Object?> get props => [];
}

class StartLoadingBabyHeightState extends BabyHeightState {

  const StartLoadingBabyHeightState();

  @override
  List<Object?> get props => [];
}

class LoadingBabyHeightSuccessful extends BabyHeightState {

  const LoadingBabyHeightSuccessful();

  @override
  List<Object?> get props => [];
}

class StartEditBabyHeightState extends BabyHeightState {

  const StartEditBabyHeightState();

  @override
  List<Object?> get props => [];
}

class SaveBabyHeightSuccessful extends BabyHeightState {

  const SaveBabyHeightSuccessful();

  @override
  List<Object?> get props => [];
}

class LoadingBabyHeightFailState extends BabyHeightState {

  const LoadingBabyHeightFailState();

  @override
  List<Object?> get props => [];
}
