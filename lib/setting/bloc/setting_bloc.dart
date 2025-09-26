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
    on<UpdateUsingBiometricEvent>(_onToggleBiometricEnabled);
    on<UpdateUserGoal>(_onUpdateUserGoal);
  }

  void _onLoadLocalData(LoadLocalDataEvent event, Emitter<SettingState> emit) async {
    bool isUsingAverageValue = LocalStorageService.isUsingAverageValue();
    int cycleLength = await LocalStorageService.getCycleLength();
    int menstruationLength = await LocalStorageService.getMenstruationLength();

    UserGoal goal = LocalStorageService.getGoal();
    bool useBiometric = LocalStorageService.checkUsingBiometric();

    emit(UpdateCycleLengthState(cycleLength));
    emit(UpdateMenstruationLengthState(menstruationLength));
    emit(UpdateUsingAverageState(isUsingAverageValue));
    emit(UpdateUsingBiometricState(useBiometric));
    emit(UpdateGoalState(goal));
  }

  Future<void> _onUpdateCycleLength(UpdateCycleLengthEvent event, Emitter<SettingState> emit) async {
    await LocalStorageService.updateCycleLength(event.value);
    emit(UpdateCycleLengthState(event.value));
  }

  Future<void> _onUpdateMenstruationLength(UpdateMenstruationLengthEvent event, Emitter<SettingState> emit) async {
    await LocalStorageService.updateMenstruationLength(event.value);
    emit(UpdateMenstruationLengthState(event.value));
  }

  Future<void> _onToggleAverage(ToggleAverageEvent event, Emitter<SettingState> emit) async {
    await LocalStorageService.updateUsingAverageValue(event.value);
    emit(UpdateUsingAverageState(event.value));
  }

  Future<void> _onToggleBiometricEnabled(UpdateUsingBiometricEvent event, Emitter<SettingState> emit) async {
    await LocalStorageService.updateUsingBiometric(event.value);
    emit(UpdateUsingBiometricState(event.value));
  }

  Future<void> _onUpdateUserGoal(UpdateUserGoal event, Emitter<SettingState> emit) async {
    await LocalStorageService.updateGoal(event.goal);
    emit(UpdateGoalState(event.goal));
  }
}
