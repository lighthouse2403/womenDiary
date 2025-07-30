import 'package:equatable/equatable.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocalDataEvent extends SettingEvent {
  const LoadLocalDataEvent();
}

class UpdateCycleLengthEvent extends SettingEvent {
  final int value;

  const UpdateCycleLengthEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateMenstruationLengthEvent extends SettingEvent {
  final int value;

  const UpdateMenstruationLengthEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleAverageEvent extends SettingEvent {
  final bool value;

  const ToggleAverageEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateOvulationDay extends SettingEvent {
  final int value;

  const UpdateOvulationDay(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateUsingBiometricEvent extends SettingEvent {
  final bool value;

  const UpdateUsingBiometricEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateUserGoal extends SettingEvent {
  final UserGoal goal;

  const UpdateUserGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}
