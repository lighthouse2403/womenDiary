import 'package:baby_diary/baby_action/sleep/bloc/sleep_event.dart';
import 'package:baby_diary/baby_action/sleep/bloc/sleep_state.dart';
import 'package:baby_diary/baby_action/sleep/sleep_model.dart';
import 'package:bloc/src/bloc.dart';

class ExcretionBloc extends Bloc<SleepEvent, SleepState> {
  List<SleepModel> sleepList =[];
  SleepModel sleep = SleepModel.init();

  ExcretionBloc() : super(const SleepState()) {
    on<ChangeBabyEvent>(_changedBaby);
  }

  Future<void> _changedBaby(ChangeBabyEvent event, Emitter emit) async {
    sleep.babyId = event.baby.babyId;
  }
}
