import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/period/red_date.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  List<PeriodModel> redDates = [];

  HomeBloc() : super(const HomeState()) {
    on<LoadRedDateEvent>(_loadPeriods);

    on<LoadCycleEvent>((event, emit) {
      final phases = _buildPhases(event.cycleLength);
      final current = phases.firstWhere((p) => event.currentDay >= p.startDay && event.currentDay < p.startDay + p.days);
      final currentPhaseEnd = current.startDay + current.days - 1;
      final next = phases.firstWhere(
            (p) => p.startDay > event.currentDay,
        orElse: () => phases.first,
      );
      final daysUntilNext = next.startDay > event.currentDay
          ? next.startDay - event.currentDay
          : (event.cycleLength - event.currentDay + next.startDay);

      emit(LoadedRedDateState(
        currentDay: event.currentDay,
        cycleLength: event.cycleLength,
        phases: phases,
        currentPhase: current,
        nextPhase: next,
        daysUntilNext: daysUntilNext,
        redDate: [],
      ));
    });
  }

  Future<void> _loadPeriods(LoadRedDateEvent event, Emitter<HomeState> emit) async {
    try {
      redDates = await DatabaseHandler.getAllPeriod();
    } catch (error) {
    }
  }

  List<PhaseModel> _buildPhases(int length) {
    final menstruation = 5;
    final follicular = (length * 0.3).round();
    final ovulation = 1;
    final luteal = length - menstruation - follicular - ovulation;

    int s = 1;
    final List<PhaseModel> list = [];
    list.add(PhaseModel("🩸", menstruation, Colors.pinkAccent, s)); s += menstruation;
    list.add(PhaseModel("🌱", follicular, Colors.lightBlueAccent, s)); s += follicular;
    list.add(PhaseModel("🌼", ovulation, Colors.yellowAccent, s)); s += ovulation;
    list.add(PhaseModel("🌙", luteal, Colors.deepPurpleAccent, s));
    return list;
  }
}
