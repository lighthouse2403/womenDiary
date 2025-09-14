import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/local_storage_service.dart';

class CycleBloc extends Bloc<CycleEvent, CycleState> {
  List<CycleModel> cycleList = [];
  CycleModel cycleDetail = CycleModel(DateTime.now());
  List<ActionModel> actions = [];

  CycleBloc() : super(const CycleState()) {
    on<LoadAllCycleEvent>(_loadAllCycle);
    on<DeleteCycleEvent>(_deleteCycle);
    on<CreateCycleEvent>(_createCycle);
    on<LoadCycleDetailEvent>(_loadCycleDetail); // ✅ thêm handler
    on<UpdateCycleNoteEvent>(_updateNote); // ✅ thêm handler
    on<UpdateCycleEvent>(_updateCycleDetail); // ✅ thêm handler
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
      // Thêm chu kỳ mới vào DB
      bool isUsingAverage = LocalStorageService.isUsingAverageValue();
      if (isUsingAverage) {
        event.newCycle.cycleEndTime = event.newCycle.cycleStartTime.add(Duration(days: LocalStorageService.getAverageCycleLength() - 1));
      }
      await DatabaseHandler.insertCycle(event.newCycle);

      // Lấy lại toàn bộ danh sách cycle và sắp xếp theo ngày bắt đầu
      cycleList = await DatabaseHandler.getAllCycle();
      cycleList.sort((a, b) => a.cycleStartTime.compareTo(b.cycleStartTime));

      int totalCycleDays = 0;
      int countCycle = 0;

      // Update cycleEndTime dựa theo cycleStartTime của cycle kế tiếp
      for (int i = 0; i < cycleList.length; i++) {
        if (i < cycleList.length - 1) {
          cycleList[i].cycleEndTime =
              cycleList[i + 1].cycleStartTime.subtract(const Duration(days: 1));

          totalCycleDays += cycleList[i].cycleEndTime.difference(cycleList[i].cycleStartTime).inDays;
          countCycle += 1;
        }
        await DatabaseHandler.updateCycle(cycleList[i]);
      }
      await LocalStorageService.updateAverageCycleLength((totalCycleDays/countCycle).round());
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
      // emit state lỗi nếu cần
    }
  }

  Future<void> _loadCycleDetail(LoadCycleDetailEvent event, Emitter<CycleState> emit) async {
    try {
      cycleDetail = await DatabaseHandler.getCycle(event.cycle.id);
      actions = await DatabaseHandler.getActionsByCycle(event.cycle.id);
      print('action list: ${actions.map((e) => e.toJson())}');
      emit(LoadedCycleDetailState(cycleDetail));
      emit(LoadedActionsState(actions));
    } catch (error) {
      // Có thể emit state lỗi ở đây
    }
  }

  Future<void> _updateNote(UpdateCycleNoteEvent event, Emitter<CycleState> emit) async {
    try {
      cycleDetail.note =event.note;

    } catch (error) {
      // Có thể emit state lỗi ở đây
    }
  }

  Future<void> _updateCycleDetail(UpdateCycleEvent event, Emitter<CycleState> emit) async {
    try {
      await DatabaseHandler.updateCycle(cycleDetail);
      emit(CycleSavedSuccessfullyState());
    } catch (error) {
      // Có thể emit state lỗi ở đây
    }
  }

  Future<void> _deleteCycle(DeleteCycleEvent event, Emitter<CycleState> emit) async {
    try {
      await DatabaseHandler.deleteCycleById(event.id);
      cycleList.removeWhere((e) => e.id == event.id);

      /// Update average cycle length
      cycleList.sort((a, b) => a.cycleStartTime.compareTo(b.cycleStartTime));

      int totalCycleDays = 0;
      int countCycle = 0;
      for (int i = 0; i < cycleList.length; i++) {
        if (i < cycleList.length - 1) {
          cycleList[i].cycleEndTime =
              cycleList[i + 1].cycleStartTime.subtract(const Duration(days: 1));

          totalCycleDays += cycleList[i].cycleEndTime.difference(cycleList[i].cycleStartTime).inDays;
          countCycle += 1;
        }

        await DatabaseHandler.updateCycle(cycleList[i]);
      }
      await LocalStorageService.updateAverageCycleLength((totalCycleDays/countCycle).round());
      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }
}
