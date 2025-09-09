import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadCycleEvent>(_onLoadLocalData);
  }

  Future<void> _onLoadLocalData(
      LoadCycleEvent event, Emitter<HomeState> emit) async {

    emit(state.copyWith(isLoadingCycle: true, isLoadingSchedule: true));

    final lastCycleFuture = await DatabaseHandler.getLastCycle();
    final longestCycle = await DatabaseHandler.getLongestCycle();
    final shortestCycle = await DatabaseHandler.getShortestCycle();

    final schedulesFuture = DatabaseHandler.getAllSchedule();

    // --- Load cycle ---
    final lastCycle = await lastCycleFuture;
    DateTime lastCycleEndTime = lastCycle.cycleEndTime;
    if (lastCycleEndTime.isBefore(DateTime.now())) {
      lastCycle.cycleEndTime = DateTime.now().add(Duration(days: 1));
      DatabaseHandler.updateCycle(lastCycle);
    }
    final cycleLength = lastCycle.cycleEndTime.difference(lastCycle.cycleStartTime).inDays + 1;
    final longestLength = longestCycle.cycleEndTime.difference(longestCycle.cycleStartTime).inDays + 1;
    final shortestLength = shortestCycle.cycleEndTime.difference(shortestCycle.cycleStartTime).inDays + 1;
    final averageCycleLength = await DatabaseHandler.getAverageCycleLength();

    final menstruationLength = lastCycle.menstruationEndTime.difference(lastCycle.cycleStartTime).inDays + 1;

    final currentDay = DateTime.now().difference(lastCycle.cycleStartTime).inDays;

    final phases = await _buildPhases(cycleLength, menstruationLength);
    final currentPhase = _findCurrentPhase(phases, currentDay, cycleLength);
    DateTime? ovalutionDay = lastCycle.cycleEndTime.subtract(Duration(days: 14));

    final nextPhase = phases.firstWhere(
          (p) => p.startDay > currentDay,
      orElse: () => phases.first,
    );

    final remainDays = cycleLength - currentDay;

    final cycleData = CycleData(
      currentDay: currentDay,
      cycleLength: cycleLength,
      averageCycleLength: averageCycleLength,
      startDay: lastCycle.cycleStartTime ,
      endDay: lastCycle.cycleEndTime,
      ovalutionDay: ovalutionDay,
      remainDays: remainDays,
      longestCycle: longestLength,
      shortestCycle: shortestLength,
      currentPhase: currentPhase,
      phases: phases,
    );

    emit(state.copyWith(
      cycle: cycleData,
      isLoadingCycle: false,
    ));

    // --- Load schedule ---
    final schedules = await schedulesFuture;
    emit(state.copyWith(
      schedules: schedules,
      isLoadingSchedule: false,
    ));
  }

  Future<List<PhaseModel>> _buildPhases(
      int cycleLength, int menstruationLength) async {
    final int ovulationDay = cycleLength - 14;
    final int fertileStart = ovulationDay - 5;
    final int fertileEnd = ovulationDay + 1;
    final int afterFertileStart = fertileEnd + 1;

    return [
      PhaseModel("🩸", menstruationLength, Colors.pink.shade400, 1),
      PhaseModel("🍃", fertileStart - (menstruationLength + 1),
          Colors.teal.shade200, menstruationLength + 1),
      PhaseModel("🌸", fertileEnd - fertileStart + 1, Colors.amber.shade400,
          fertileStart),
      PhaseModel(
          "🌙", cycleLength - fertileEnd, Colors.purple.shade200, afterFertileStart),
    ];
  }

  PhaseModel _findCurrentPhase(List<PhaseModel> phases, int currentDay, int cycleLength) {
    for (final phase in phases) {
      final start = phase.startDay;
      final end = start + phase.days - 1;
      if (currentDay >= start && currentDay <= end) {
        return phase;
      }
    }

    // Nếu currentDay vượt quá (cuối chu kỳ) thì wrap về phase đầu tiên
    return phases.last;
  }
}
