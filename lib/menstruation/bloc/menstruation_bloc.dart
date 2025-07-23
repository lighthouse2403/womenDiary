import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/period_model.dart';

class MenstruationBloc extends Bloc<MenstruationEvent, MenstruationState> {
  List<MenstruationModel> menstruationList = [];

  MenstruationBloc() : super(const MenstruationState()) {
    on<LoadAllMenstruationEvent>(_loadAllMenstruation);
  }

  Future<void> _loadAllMenstruation(LoadAllMenstruationEvent event, Emitter<MenstruationState> emit) async {
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
      PhaseModel("🩸", menstruationLength, Colors.pinkAccent, 1), // ngày bắt đầu
      PhaseModel("🌱", follicularLength, Colors.lightBlueAccent, menstruationLength + 1),
      PhaseModel("🌼", 1, Colors.yellowAccent, ovulationDay),
      PhaseModel("🌙", lutealLength, Colors.deepPurpleAccent, ovulationDay + 1),
    ];
    return phases;
  }
}
