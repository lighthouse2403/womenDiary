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
    int cycleLength = await LocalStorageService.getCycleLength();
    int menstruationLength = await LocalStorageService.getMenstruationLength();
    bool isUsingAverageValue = await LocalStorageService.isUsingAverageValue();

    List<CycleModel> menstruationList = await DatabaseHandler.getAllCycle();
    CycleModel lastMenstruation = menstruationList.first;
    int currentDay = DateTime.now().difference(lastMenstruation.cycleStartTime).inDays;

    if (isUsingAverageValue && menstruationList.length > 1) {
      int numberOfCycle = 0;
      int allMenstruationDay = 0;
      menstruationList.forEach((menstruation) {
        numberOfCycle += 1;
        int numberOfMenstruation = menstruation.cycleEndTime.difference(menstruation.cycleStartTime).inDays;
        allMenstruationDay += numberOfMenstruation;
      });
      menstruationLength = (allMenstruationDay/numberOfCycle).round();
      cycleLength = (menstruationList.last.cycleStartTime.difference(menstruationList.first.cycleStartTime).inDays/(menstruationList.length - 1)).round();
    }

    /// Show phase information
    final phases = await _buildPhases();
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

  Future<List<PhaseModel>> _buildPhases() async {
    final int cycleLength = await LocalStorageService.getCycleLength();
    final int menstruationLength = await LocalStorageService.getMenstruationLength();

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
