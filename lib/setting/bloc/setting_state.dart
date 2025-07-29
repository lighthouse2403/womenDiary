import 'package:equatable/equatable.dart';

enum UserGoal { avoidPregnancy, tryingToConceive }

class SettingState extends Equatable {
  final int cycleLength;
  final int menstruationLength;
  final bool useFixedOvulation;
  final int ovulationDay;
  final bool isPinEnabled;
  final UserGoal goal;

  const SettingState({
    required this.cycleLength,
    required this.menstruationLength,
    required this.useFixedOvulation,
    required this.ovulationDay,
    required this.isPinEnabled,
    required this.goal,
  });

  @override
  List<Object> get props => [
    cycleLength,
    menstruationLength,
    useFixedOvulation,
    ovulationDay,
    isPinEnabled,
    goal,
  ];
}
