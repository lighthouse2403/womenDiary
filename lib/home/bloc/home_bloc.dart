import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<CycleModel> menstruationList = [];

  HomeBloc() : super(const HomeState()) {
    on<LoadCycleEvent>(_onLoadLocalData);
  }

  void _onLoadLocalData(LoadCycleEvent event, Emitter<HomeState> emit) async {
    CycleModel? lastCycle = await DatabaseHandler.getLastCycle();
    if ( lastCycle != null && lastCycle.cycleEndTime.isPast()) {
      lastCycle.cycleEndTime = DateTime.now().add(Duration(days: 2));
      await DatabaseHandler.updateCycle(lastCycle);
    }

    int cycleLength = lastCycle != null
        ? lastCycle.cycleEndTime.difference(lastCycle.cycleStartTime).inDays + 1
        : await LocalStorageService.getCycleLength();

    int menstruationLength = lastCycle != null
        ? lastCycle.menstruationEndTime.difference(lastCycle.cycleStartTime).inDays + 1
        : await LocalStorageService.getMenstruationLength();

    int currentDay = DateTime.now().difference(lastCycle?.cycleStartTime ?? DateTime.now()).inDays + 1;
    print('currentDay: ${currentDay}');

    /// Show phase information
    final phases = await _buildPhases(cycleLength, menstruationLength);
    final currentPhase = phases.firstWhere((p) => cycleLength >= p.startDay && currentDay < p.startDay + p.days);
    final nextPhase = phases.firstWhere(
          (p) => p.startDay > currentDay,
      orElse: () => phases.first,
    );
    final daysUntilNext = nextPhase.startDay > currentDay
        ? nextPhase.startDay - currentDay
        : (cycleLength - currentDay + nextPhase.startDay);

    print('cycleLength: ${cycleLength}');
    print('phases: ${phases.length}');

    emit(LoadedCycleState(
      currentDay: currentDay,
      cycleLength: cycleLength,
      phases: phases,
      currentPhase: currentPhase,
      nextPhase: nextPhase,
      daysUntilNext: daysUntilNext,
      periodList: [],
    ));

    List<ScheduleModel> schedules = await DatabaseHandler.getAllSchedule();
    emit(LoadedScheduleState(schedules));
  }

  Future<List<PhaseModel>> _buildPhases(int cycleLength, int menstruationLength) async {
    final int ovulationDay = cycleLength - 14;
    final int fertileStart = ovulationDay - 5;
    final int fertileEnd = ovulationDay + 1;
    final int afterFertileStart = fertileEnd + 1;

    // 🩸 Menstruation
    PhaseModel mensPhase = PhaseModel(
        "🩸",
        menstruationLength,
        Colors.pink.shade400,
        1
    );

    // 🍃 Safe Early
    final int safeEarlyStart = menstruationLength + 1;
    final int safeEarlyLength = fertileStart - safeEarlyStart;
    PhaseModel safeEarlyPhase = PhaseModel(
        "🍃",
        safeEarlyLength,
        Colors.teal.shade200,
        safeEarlyStart
    );

    // 🌸 Fertile
    final int fertileLength = fertileEnd - fertileStart + 1;
    PhaseModel fertilePhase = PhaseModel(
        "🌸",
        fertileLength,
        Colors.amber.shade400,
        fertileStart
    );

    // 🌙 Safe Late
    final int safeLateLength = cycleLength - fertileEnd;
    PhaseModel safeLatePhase = PhaseModel(
        "🌙",
        safeLateLength,
        Colors.purple.shade200,
        afterFertileStart
    );

    final List<PhaseModel> phases = [
      mensPhase,
      safeEarlyPhase,
      fertilePhase,
      safeLatePhase
    ];

    return phases;
  }
}
