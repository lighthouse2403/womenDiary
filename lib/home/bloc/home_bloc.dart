import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<MenstruationModel> menstruationList = [];

  HomeBloc() : super(const HomeState()) {
    on<LoadRedDateEvent>(_loadPeriods);

    on<LoadCycleEvent>((event, emit) {
      final phases = _buildPhases();
      int cycleLength = LocalStorageService.getCycleLength();
      int currentDay = 10;
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
    });
  }

  Future<void> _loadPeriods(LoadRedDateEvent event, Emitter<HomeState> emit) async {
    try {
      menstruationList = await DatabaseHandler.getAllMenstruation();
    } catch (error) {
    }
  }

  List<PhaseModel> _buildPhases() {
    int cycleLength = LocalStorageService.getCycleLength();
    int menstruationLength = LocalStorageService.getMenstruationLength();
    int ovulationDay = cycleLength - 14;
    int follicularLength = ovulationDay - menstruationLength;
    int lutealLength = cycleLength - ovulationDay - 1;

    List<PhaseModel> phases = [
      PhaseModel("🩸", menstruationLength, Colors.red.shade200, 1),
      PhaseModel("🌱", follicularLength, Colors.lightBlueAccent, menstruationLength + 1),
      PhaseModel("🌼", 1, Colors.yellowAccent, ovulationDay),
      PhaseModel("🌙", lutealLength, Colors.deepOrange.shade200, ovulationDay + 1),
    ];
    return phases;
  }
}
