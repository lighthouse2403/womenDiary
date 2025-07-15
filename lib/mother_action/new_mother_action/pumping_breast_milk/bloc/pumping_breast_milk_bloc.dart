import 'package:baby_diary/mother_action/new_mother_action/pumping_breast_milk/bloc/pumping_breast_milk_event.dart';
import 'package:baby_diary/mother_action/new_mother_action/pumping_breast_milk/bloc/pumping_breast_milk_state.dart';
import 'package:baby_diary/mother_action/new_mother_action/pumping_breast_milk/milking_model.dart';
import 'package:bloc/src/bloc.dart';

class MilkingBloc extends Bloc<PumpingBreastMilkEvent, PumpingBreastMilkState> {
  List<PumpingBreastMilkModel> pumpingBreastMilkList =[];
  PumpingBreastMilkModel? currentPumpingBreastMilk;

  MilkingBloc() : super(PumpingBreastMilkState()) {
    on<SavePumpingBreastMilkEvent>(_savePumpingBreastMilk);
    on<DeletePumpingBreastMilkEvent>(_deletePumpingBreastMilk);
  }

  void _savePumpingBreastMilk(SavePumpingBreastMilkEvent event, Emitter emit) async {
    currentPumpingBreastMilk = event.pumpingBreastMilk;
  }

  void _deletePumpingBreastMilk(DeletePumpingBreastMilkEvent event, Emitter emit) async {
  }
}
