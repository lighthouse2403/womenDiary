// setting_event.dart
import 'package:women_diary/setting/bloc/setting_state.dart';

abstract class SettingEvent {}

class UpdateCycleLength extends SettingEvent {
  final int value;
  UpdateCycleLength(this.value);
}

class UpdateMenstruationLength extends SettingEvent {
  final int value;
  UpdateMenstruationLength(this.value);
}

class ToggleFixedOvulation extends SettingEvent {
  final bool value;
  ToggleFixedOvulation(this.value);
}

class UpdateOvulationDay extends SettingEvent {
  final int value;
  UpdateOvulationDay(this.value);
}

class TogglePinEnabled extends SettingEvent {
  final bool value;
  TogglePinEnabled(this.value);
}

class UpdateUserGoal extends SettingEvent {
  final UserGoal goal;
  UpdateUserGoal(this.goal);
}
