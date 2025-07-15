import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:equatable/equatable.dart';

class ExcretionEvent extends Equatable {
  const ExcretionEvent();
  @override
  List<Object?> get props => [];
}

class ChangeBabyEvent extends ExcretionEvent {
  const ChangeBabyEvent(this.baby);
  final BabyModel baby;

  @override
  List<Object?> get props => [baby.babyId];
}
