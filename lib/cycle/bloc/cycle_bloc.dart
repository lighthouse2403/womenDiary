import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleBloc extends Bloc<CycleEvent, CycleState> {
  List<CycleModel> cycleList = [];

  CycleBloc() : super(const CycleState()) {
    on<LoadAllCycleEvent>(_loadAllCycle);
    on<DeleteCycleEvent>(_deleteCycle);
    on<CreateCycleEvent>(_createCycle);

  }

  Future<void> _loadAllCycle(LoadAllCycleEvent event, Emitter<CycleState> emit) async {
    try {
      cycleList = await DatabaseHandler.getAllCycle();
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }

  Future<void> _createCycle(CreateCycleEvent event, Emitter<CycleState> emit) async {
    try {
      if (cycleList.isNotEmpty) {
        CycleModel lastCycle = cycleList.first;
        lastCycle.cycleEndTime = event.newCycle.cycleEndTime.subtract(Duration(days: 1));
        await DatabaseHandler.updateCycle(lastCycle);

      }
      await DatabaseHandler.insertCycle(event.newCycle);
      cycleList.add(event.newCycle);
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }

  Future<void> _deleteCycle(DeleteCycleEvent event, Emitter<CycleState> emit) async {
    try {
      await DatabaseHandler.deleteCycleById(event.id);
      cycleList.removeWhere((e) => e.id == event.id);
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }
}
