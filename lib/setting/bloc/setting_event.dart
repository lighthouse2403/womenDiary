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

class UpdateCycleLength extends SettingEvent {
  final int value;

  const UpdateCycleLength(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateMenstruationLength extends SettingEvent {
  final int value;

  const UpdateMenstruationLength(this.value);

  @override
  List<Object?> get props => [value];
}

class ToggleFixedOvulation extends SettingEvent {
  final bool value;

  const ToggleFixedOvulation(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateOvulationDay extends SettingEvent {
  final int value;

  const UpdateOvulationDay(this.value);

  @override
  List<Object?> get props => [value];
}

class TogglePinEnabled extends SettingEvent {
  final bool value;

  const TogglePinEnabled(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateUserGoal extends SettingEvent {
  final UserGoal goal;

  const UpdateUserGoal(this.goal);

  @override
  List<Object?> get props => [goal];
}
