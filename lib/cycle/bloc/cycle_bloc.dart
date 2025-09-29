import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/notification_service.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/local_storage_service.dart';

enum CycleNotificationType {
  follicular(0),
  ovulation(1),
  ovulationDay(2),
  luteal(2);

  final int value;
  const CycleNotificationType(this.value);
}

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

      /// Create new notification
      handleCycleNotification(event.newCycle);

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

      for (int i = 0; i < cycleList.length; i++) {
        if (i < cycleList.length - 1) {
          cycleList[i].cycleEndTime =
              cycleList[i + 1].cycleStartTime.subtract(const Duration(days: 1));
        }

        await DatabaseHandler.updateCycle(cycleList[i]);
      }
      CycleModel lastCycle = await DatabaseHandler.getLastCycle();
      handleCycleNotification(lastCycle);

      emit(LoadedAllCycleState(cycleList));
    } catch (error) {
    }
  }

  void handleCycleNotification(CycleModel lastCycle) async {
    await NotificationService().cancelNotification(CycleNotificationType.follicular.value);
    await NotificationService().cancelNotification(CycleNotificationType.ovulation.value);
    await NotificationService().cancelNotification(CycleNotificationType.ovulationDay.value);
    await NotificationService().cancelNotification(CycleNotificationType.luteal.value);

    DateTime menstruationNotification = DateTime(
        lastCycle.menstruationEndTime.year,
        lastCycle.menstruationEndTime.month,
        lastCycle.menstruationEndTime.day,
        8,
        0
    );

    DateTime ovulationPhase = lastCycle.cycleEndTime.subtract(Duration(days: 18));
    DateTime ovulationNotification = DateTime(
        ovulationPhase.year,
        ovulationPhase.month,
        ovulationPhase.day,
        8,
        0
    );

    DateTime ovulationDate = lastCycle.cycleEndTime.subtract(Duration(days: 15));
    DateTime ovulationDayNotification = DateTime(
        ovulationDate.year,
        ovulationDate.month,
        ovulationDate.day,
        8,
        0
    );

    DateTime lutealDate = lastCycle.cycleEndTime.subtract(Duration(days: 13));
    DateTime lutealNotification = DateTime(
        lutealDate.year,
        lutealDate.month,
        lutealDate.day,
        8,
        0
    );

    /// Add notification if it's the future
    if (lastCycle.menstruationEndTime.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: CycleNotificationType.follicular.value,
        title: "Giai đoạn an toàn",
        body: '${lastCycle.menstruationEndTime.globalDateFormat()} ~ ${ovulationPhase.globalDateFormat()}',
        scheduledTime: menstruationNotification,
      );
    }

    if (ovulationNotification.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: CycleNotificationType.ovulation.value,
        title: "Giai đoạn nguyên hiểm",
        body: '${lastCycle.menstruationEndTime.globalDateFormat()} ~ ${ovulationPhase.globalDateFormat()}',
        scheduledTime: ovulationNotification,
      );
    }

    if (ovulationDate.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: CycleNotificationType.ovulationDay.value,
        title: "Ngày rụng trứng",
        body: '${ovulationDate.globalDateFormat()}',
        scheduledTime: ovulationDayNotification,
      );
    }

    if (lutealDate.isAfter(DateTime.now())) {
      await NotificationService().scheduleNotification(
        id: CycleNotificationType.luteal.value,
        title: "Giai đoạn an toàn",
        body: '${lutealDate} ~ ${lastCycle.cycleEndTime.globalDateFormat()}',
        scheduledTime: lutealNotification,
      );
    }

  }
}
