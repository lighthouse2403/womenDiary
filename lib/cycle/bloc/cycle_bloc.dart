import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/local_storage_service.dart';

class CycleBloc extends Bloc<CycleEvent, CycleState> {
  List<CycleModel> cycleList = [];

  CycleBloc() : super(const CycleState()) {
    on<LoadAllCycleEvent>(_loadAllCycle);
    on<DeleteCycleEvent>(_deleteCycle);
    on<CreateCycleEvent>(_createCycle);
    on<LoadCycleDetailEvent>(_loadCycleDetail); // ✅ thêm handler
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
        lastCycle.cycleEndTime =
            event.newCycle.cycleEndTime.subtract(const Duration(days: 1));
        await DatabaseHandler.updateCycle(lastCycle);
      }

      // --- Tính chu kỳ trung bình --
      bool isUsingAverage = LocalStorageService.isUsingAverageValue();
      int averageCycleLength = LocalStorageService.getCycleLength();

      if ((cycleList.length > 1) && isUsingAverage) {
        int totalCycleDays = 0;
        int countCycle = 0;

        for (var cycle in cycleList) {
          totalCycleDays += cycle.cycleEndTime
              .difference(cycle.cycleStartTime)
              .inDays + 1;
          countCycle++;
        }

        if (countCycle > 0) {
          averageCycleLength = (totalCycleDays / countCycle).round();
        }

        LocalStorageService.updateAverageCycleLength(averageCycleLength);
      }

      event.newCycle.cycleEndTime = event.newCycle.cycleStartTime.add(Duration(days: averageCycleLength -1));

      // Lưu cycle mới
      await DatabaseHandler.insertCycle(event.newCycle);
      cycleList.add(event.newCycle);

      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
      // có thể emit state lỗi
    }
  }

  Future<void> _loadCycleDetail(
      LoadCycleDetailEvent event, Emitter<CycleState> emit) async {
    try {
      final cycle = await DatabaseHandler.getCycle(event.cycle.id);
      emit(LoadedCycleDetailState(cycle));
    } catch (error) {
      // Có thể emit state lỗi ở đây
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
