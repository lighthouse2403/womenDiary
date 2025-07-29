import 'package:equatable/equatable.dart';

enum UserGoal {
  avoidPregnancy(0),
  tryingToConceive(1);

  final int value;
  const UserGoal(this.value);

  static UserGoal fromInt(int value) {
    return UserGoal.values.firstWhere(
          (e) => e.value == value,
      orElse: () => UserGoal.avoidPregnancy, // fallback mặc định
    );
  }
}

class SettingState extends Equatable {
  const SettingState();
  @override
  List<Object> get props => [];
}

class UpdateUsingAverageState extends SettingState {
  const UpdateUsingAverageState(this.isUsingAverage);
  final bool isUsingAverage;
  @override
  List<Object> get props => [isUsingAverage];
}

class UpdateCycleLengthState extends SettingState {
  const UpdateCycleLengthState(this.value);
  final int value;
  @override
  List<Object> get props => [value];
}

class UpdateMenstruationLengthState extends SettingState {
  const UpdateMenstruationLengthState(this.value);
  final int value;
  @override
  List<Object> get props => [value];
}

class UpdateUsingPINState extends SettingState {
  const UpdateUsingPINState(this.isUsingPIN);
  final bool isUsingPIN;
  @override
  List<Object> get props => [isUsingPIN];
}

class UpdateGoalState extends SettingState {
  const UpdateGoalState(this.goal);
  final UserGoal goal;
  @override
  List<Object> get props => [goal];
}