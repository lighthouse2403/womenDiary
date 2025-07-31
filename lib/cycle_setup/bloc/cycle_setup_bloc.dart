import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_event.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_state.dart';
import 'package:women_diary/database/local_storage_service.dart';

class CycleSetupBloc extends Bloc<CycleSetupEvent, CycleSetupState> {
  CycleSetupBloc() : super(CycleSetupState()) {
    on<CycleLengthChangedEvent>(_onChangingCycleLength);
    on<MenstruationLengthChangedEvent>(_onChangingMenstruationLength);

  }

  void _onChangingCycleLength(CycleLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    LocalStorageService.updateCycleLength(event.cycleLength);
  }

  void _onChangingMenstruationLength(MenstruationLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    LocalStorageService.updateCycleLength(event.menstruationLength);
  }
}
