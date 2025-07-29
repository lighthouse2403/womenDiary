import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'setting_event.dart';
import 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingState()) {
    on<LoadLocalDataEvent>(_onLoadLocalData);
    on<UpdateCycleLengthEvent>(_onUpdateCycleLength);
    on<UpdateMenstruationLengthEvent>(_onUpdateMenstruationLength);
    on<ToggleAverageEvent>(_onToggleAverage);
    on<UpdatePINEvent>(_onTogglePinEnabled);
    on<UpdateUserGoal>(_onUpdateUserGoal);
  }

  void _onLoadLocalData(LoadLocalDataEvent event, Emitter<SettingState> emit) {
    bool isUsingAverageValue = LocalStorageService.isUsingAverageValue();
    int cycleLength = LocalStorageService.getCycleLength();
    int menstruationLength = LocalStorageService.getMenstruationLength();

    UserGoal goal = LocalStorageService.getGoal();
    String pin = LocalStorageService.getPIN();

    emit(UpdateCycleLengthState(cycleLength));
    emit(UpdateMenstruationLengthState(menstruationLength));
    emit(UpdateUsingAverageState(isUsingAverageValue));
    emit(UpdateUsingPINState(pin.isNotEmpty));
    emit(UpdateGoalState(goal));
  }

  void _onUpdateCycleLength(UpdateCycleLengthEvent event, Emitter<SettingState> emit) {
    LocalStorageService.updateCycleLength(event.value);
    emit(UpdateCycleLengthState(event.value));
  }

  void _onUpdateMenstruationLength(UpdateMenstruationLengthEvent event, Emitter<SettingState> emit) {
    LocalStorageService.updateMenstruationLength(event.value);
    emit(UpdateMenstruationLengthState(event.value));
  }

  void _onToggleAverage(ToggleAverageEvent event, Emitter<SettingState> emit) {
    LocalStorageService.updateUsingAverageValue(event.value);
    emit(UpdateUsingAverageState(event.value));
  }

  void _onTogglePinEnabled(UpdatePINEvent event, Emitter<SettingState> emit) {
    LocalStorageService.updatePIN(event.value);
    emit(UpdateUsingPINState(event.value.isNotEmpty));
  }

  void _onUpdateUserGoal(UpdateUserGoal event, Emitter<SettingState> emit) {
    LocalStorageService.updateGoal(event.goal);
    emit(UpdateGoalState(event.goal));
  }
}
