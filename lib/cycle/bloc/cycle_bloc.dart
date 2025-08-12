import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleBloc extends Bloc<CycleEvent, CycleState> {
  List<CycleModel> cycleList = [];

  CycleBloc() : super(const CycleState()) {
    on<LoadAllCycleEvent>(_loadAllCycle);
    on<DeleteCycleEvent>(_deleteCycle);

  }

  Future<void> _loadAllCycle(LoadAllCycleEvent event, Emitter<CycleState> emit) async {
    try {
      cycleList = await DatabaseHandler.getAllCycle();
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }

  Future<void> _deleteCycle(DeleteCycleEvent event, Emitter<CycleState> emit) async {
    try {
      await DatabaseHandler.deleteCycle(event.startTime.startOfDay().millisecondsSinceEpoch);
      cycleList = await DatabaseHandler.getAllCycle();
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }
}
