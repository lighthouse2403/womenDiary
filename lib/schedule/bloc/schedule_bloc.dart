import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/schedule/bloc/schedule_event.dart';
import 'package:women_diary/schedule/bloc/schedule_state.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  /// Schedule list
  List<ScheduleModel> scheduleList = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();

  /// Schedule detail
  ScheduleModel scheduleDetail = ScheduleModel.init();

  ScheduleBloc() : super(ScheduleState()) {
    on<LoadScheduleEvent>(_onLoadSchedules);
    on<UpdateDateRangeEvent>(_onUpdateDateRange);

    /// Schedule detail
    on<InitScheduleDetailEvent>(_onLoadScheduleDetail);
    on<UpdateTimeEvent>(_onUpdateTime);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<UpdateReminderEvent>(_onUpdateReminder);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<UpdateScheduleDetailEvent>(_onUpdateScheduleDetail);
    on<CreateScheduleDetailEvent>(_onCreateScheduleDetail);
    on<DeleteScheduleFromListEvent>(_onDeleteScheduleFromList);
    on<DeleteScheduleDetailEvent>(_onDeleteScheduleDetail);
  }

  Future<void> _onLoadSchedules(LoadScheduleEvent event, Emitter<ScheduleState> emit) async {
    scheduleList = await DatabaseHandler.getSchedules(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
    );
    emit(ScheduleLoadedState(scheduleList));
  }

  void _onUpdateDateRange(UpdateDateRangeEvent event, Emitter<ScheduleState> emit) async {
    startTime = event.startTime;
    endTime = event.endTime;
    scheduleList = await DatabaseHandler.getSchedules(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
    );

    emit(ScheduleLoadedState(scheduleList));
  }

  void _onDeleteScheduleFromList(DeleteScheduleFromListEvent event, Emitter<ScheduleState> emit) async {
    await DatabaseHandler.deleteSchedule(event.id);
    scheduleList.removeWhere((Schedule) => Schedule.id == event.id);
    emit(ScheduleLoadedState(scheduleList));
  }

  /// --------------------------- Schedule Detail --------------------------------
  void _onLoadScheduleDetail(InitScheduleDetailEvent event, Emitter<ScheduleState> emit) async {
    scheduleDetail = event.initialSchedule;
    emit(TimeUpdatedState(scheduleDetail.time));
  }

  void _onUpdateScheduleDetail(UpdateScheduleDetailEvent event, Emitter<ScheduleState> emit) async {
    await DatabaseHandler.updateSchedule(scheduleDetail);
    emit(ScheduleSavedSuccessfullyState());
  }

  void _onCreateScheduleDetail(CreateScheduleDetailEvent event, Emitter<ScheduleState> emit) async {
    await DatabaseHandler.insertSchedule(scheduleDetail);
    emit(ScheduleSavedSuccessfullyState());
  }

  void _onDeleteScheduleDetail(DeleteScheduleDetailEvent event, Emitter<ScheduleState> emit) async {
    await DatabaseHandler.deleteSchedule(event.id);
    scheduleDetail = ScheduleModel.init();
    emit(ScheduleSavedSuccessfullyState());
  }

  void _onUpdateTime(UpdateTimeEvent event, Emitter<ScheduleState> emit) async {
    scheduleDetail.time = event.time;
    emit(TimeUpdatedState(event.time));
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<ScheduleState> emit) async {
    scheduleDetail.title = event.title;
    emit(SaveButtonState(scheduleDetail.title.isNotEmpty));
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<ScheduleState> emit) async {
    scheduleDetail.note = event.note;
  }

  void _onUpdateReminder(UpdateReminderEvent event, Emitter<ScheduleState> emit) async {
    scheduleDetail.isReminderOn = event.isReminderOn;
    emit(ReminderUpdatedState(event.isReminderOn));
  }
}
