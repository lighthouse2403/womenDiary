import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<LoadCycleEvent>(_onLoadLocalData);
    on<EndCycleEvent>(_onEndCycle);

  }

  Future<void> _onLoadLocalData(
      LoadCycleEvent event, Emitter<HomeState> emit) async {

    emit(state.copyWith(isLoadingCycle: true, isLoadingSchedule: true));

    final cycleData = await _generateCycleData();
    emit(state.copyWith(cycle: cycleData, isLoadingCycle: false));

    // --- Load schedule ---
    final schedulesFuture = DatabaseHandler.getAllSchedule();
    final schedules = await schedulesFuture;
    emit(state.copyWith(
      schedules: schedules,
      isLoadingSchedule: false,
    ));
  }

  Future<List<PhaseModel>> _buildPhases(int cycle, int menstruation) async {
    return PhaseFactory.createPhases(
        cycleLength: cycle,
        menstruationLength: menstruation
    );
  }

  Future<void> _onEndCycle(EndCycleEvent event, Emitter<HomeState> emit) async {
    final lastCycleFuture = await DatabaseHandler.getLastCycle();
    lastCycleFuture.cycleEndTime = DateTime.now().subtract(Duration(days: 1));
    DatabaseHandler.updateCycle(lastCycleFuture);

    /// Create new cycle
    final cycleLength = LocalStorageService.isUsingAverageValue()
        ? await DatabaseHandler.getAverageCycleLength()
        : LocalStorageService.getCycleLength();
    final menstruationLength = LocalStorageService.getMenstruationLength();
    DateTime now = DateTime.now().startOfDay();
    DateTime cycleStartTime = now;
    DateTime cycleEndTime = now.add(Duration(days: cycleLength - 1));
    DateTime menstruationEndTime = now.add(Duration(days: menstruationLength - 1));

    CycleModel newCycle = CycleModel.init(cycleStartTime, cycleEndTime, menstruationEndTime);
    DatabaseHandler.insertCycle(newCycle);

    final cycleData = await _generateCycleData();
    emit(state.copyWith(cycle: cycleData, isLoadingCycle: false));
  }

  Future<CycleData> _generateCycleData() async {
    final lastCycleFuture = await DatabaseHandler.getLastCycle();
    final longestCycle = await DatabaseHandler.getLongestCycle();
    final shortestCycle = await DatabaseHandler.getShortestCycle();

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

    final currentDay = DateTime.now().difference(lastCycle.cycleStartTime).inDays + 1;

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

    return cycleData;
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
