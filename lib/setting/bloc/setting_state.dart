// setting_state.dart
enum UserGoal { avoidPregnancy, tryingToConceive }

class SettingState {
  final int cycleLength;
  final int menstruationLength;
  final bool useFixedOvulation;
  final int ovulationDay;
  final bool isPinEnabled;
  final UserGoal goal;

  SettingState({
    required this.cycleLength,
    required this.menstruationLength,
    required this.useFixedOvulation,
    required this.ovulationDay,
    required this.isPinEnabled,
    required this.goal,
  });

  SettingState copyWith({
    int? cycleLength,
    int? menstruationLength,
    bool? useFixedOvulation,
    int? ovulationDay,
    bool? isPinEnabled,
    UserGoal? goal,
  }) {
    return SettingState(
      cycleLength: cycleLength ?? this.cycleLength,
      menstruationLength: menstruationLength ?? this.menstruationLength,
      useFixedOvulation: useFixedOvulation ?? this.useFixedOvulation,
      ovulationDay: ovulationDay ?? this.ovulationDay,
      isPinEnabled: isPinEnabled ?? this.isPinEnabled,
      goal: goal ?? this.goal,
    );
  }
}
