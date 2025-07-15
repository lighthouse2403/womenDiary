import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class SleepEvent extends Equatable {

  const SleepEvent();

  @override
  List<Object?> get props => [];
}

class ChangeBabyEvent extends SleepEvent {
  const ChangeBabyEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby.babyId];
}
