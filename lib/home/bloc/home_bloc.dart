import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<CycleModel> menstruationList = [];

  HomeBloc() : super(const HomeState()) {
    on<LoadRedDateEvent>(_loadPeriods);
    on<LoadCycleEvent>(_onLoadLocalData);
  }

  void _onLoadLocalData(LoadCycleEvent event, Emitter<HomeState> emit) async {
    CycleModel? lastCycle = await DatabaseHandler.getLastCycle();
    int cycleLength = lastCycle != null
        ? lastCycle.cycleEndTime.difference(lastCycle.cycleStartTime).inDays
        : await LocalStorageService.getCycleLength();

    int menstruationLength = lastCycle != null
        ? lastCycle.menstruationEndTime.difference(lastCycle.cycleStartTime).inDays
        : await LocalStorageService.getMenstruationLength();

    int currentDay = DateTime.now().difference(lastCycle?.cycleStartTime ?? DateTime.now()).inDays;

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

    emit(LoadedCycleState(
      currentDay: currentDay,
      cycleLength: cycleLength,
      phases: phases,
      currentPhase: currentPhase,
      nextPhase: nextPhase,
      daysUntilNext: daysUntilNext,
      periodList: [],
    ));
  }

  Future<void> _loadPeriods(LoadRedDateEvent event, Emitter<HomeState> emit) async {
    try {
      menstruationList = await DatabaseHandler.getAllCycle();
    } catch (error) {
    }
  }

  Future<List<PhaseModel>> _buildPhases(int cycleLength, int menstruationLength) async {
    final int ovulationDay = cycleLength - 14; // VD: ngày 14
    final int fertileStart = ovulationDay - 5; // VD: ngày 9
    final int fertileEnd = ovulationDay + 1;   // VD: ngày 15
    final int afterFertileStart = fertileEnd + 1;

    final List<PhaseModel> phases = [];

    phases.add(
      PhaseModel("🩸", menstruationLength, Colors.pink.shade200, 1),
    );

    final int safeEarlyStart = menstruationLength + 1;
    final int safeEarlyLength = fertileStart - safeEarlyStart;
    if (safeEarlyLength > 0) {
      phases.add(
        PhaseModel("🌱", safeEarlyLength, Colors.green.shade200, safeEarlyStart),
      );
    }

    // 🌼 Giai đoạn nguy hiểm (rụng trứng)
    final int fertileLength = fertileEnd - fertileStart + 1; // luôn = 7
    phases.add(
      PhaseModel("🌼", fertileLength, Colors.yellow.shade300, fertileStart),
    );

    // 🌙 Giai đoạn an toàn cuối kỳ
    final int safeLateLength = cycleLength - fertileEnd;
    if (safeLateLength > 0) {
      phases.add(
        PhaseModel("🌙", safeLateLength, Colors.green.shade200, afterFertileStart),
      );
    }

    return phases;
  }

  void handleMenstruationData() async {

  }
}
