import 'package:baby_diary/mother_action/new_mother_action/pumping_breast_milk/milking_model.dart';
import 'package:equatable/equatable.dart';

class PumpingBreastMilkEvent extends Equatable {

  const PumpingBreastMilkEvent();
  @override
  List<Object?> get props => [];
}

class SavePumpingBreastMilkEvent extends PumpingBreastMilkEvent {
  const SavePumpingBreastMilkEvent(this.pumpingBreastMilk);
  final PumpingBreastMilkModel pumpingBreastMilk;
  @override
  List<Object?> get props => [pumpingBreastMilk.id];
}

class DeletePumpingBreastMilkEvent extends PumpingBreastMilkEvent {

  const DeletePumpingBreastMilkEvent();

  @override
  List<Object?> get props => [];
}
