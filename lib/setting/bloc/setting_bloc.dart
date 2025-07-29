import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc()
      : super(SettingState(
    cycleLength: 28,
    menstruationLength: 5,
    useFixedOvulation: false,
    ovulationDay: 14,
    isPinEnabled: false,
    goal: UserGoal.avoidPregnancy,
  )) {
    on<LoadLocalDataEvent>(_onLoadLocalData);
    on<UpdateCycleLength>(_onUpdateCycleLength);
    on<UpdateMenstruationLength>(_onUpdateMenstruationLength);
    on<ToggleFixedOvulation>(_onToggleFixedOvulation);
    on<UpdateOvulationDay>(_onUpdateOvulationDay);
    on<TogglePinEnabled>(_onTogglePinEnabled);
    on<UpdateUserGoal>(_onUpdateUserGoal);
  }

  void _onLoadLocalData(LoadLocalDataEvent event, Emitter<SettingState> emit) {
    LocalStorageService.updateCycleLength(event.value);
    emit(state.copyWith(cycleLength: event.value));
  }

  void _onUpdateCycleLength(UpdateCycleLength event, Emitter<SettingState> emit) {
    LocalStorageService.updateCycleLength(event.value);
  }

  void _onUpdateMenstruationLength(UpdateMenstruationLength event, Emitter<SettingState> emit) {
    LocalStorageService.updateMenstruationLength(event.value);
  }

  void _onToggleFixedOvulation(ToggleFixedOvulation event, Emitter<SettingState> emit) {
  }

  void _onUpdateOvulationDay(UpdateOvulationDay event, Emitter<SettingState> emit) {
  }

  void _onTogglePinEnabled(TogglePinEnabled event, Emitter<SettingState> emit) {
  }

  void _onUpdateUserGoal(UpdateUserGoal event, Emitter<SettingState> emit) {
  }
}
