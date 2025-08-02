import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_event.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_state.dart';
import 'package:women_diary/database/local_storage_service.dart';

class CycleSetupBloc extends Bloc<CycleSetupEvent, CycleSetupState> {
  int cycleLength = 30;
  int menstruationLength = 6;

  CycleSetupBloc() : super(CycleSetupState()) {
    on<CycleLengthChangedEvent>(_onChangingCycleLength);
    on<MenstruationLengthChangedEvent>(_onChangingMenstruationLength);
    on<SubmitCycleInformationEvent>(_submitCycleInformation);

  }

  void _onChangingCycleLength(CycleLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    cycleLength = event.cycleLength;
  }

  void _onChangingMenstruationLength(MenstruationLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    menstruationLength = event.menstruationLength;
  }

  void _submitCycleInformation(SubmitCycleInformationEvent event, Emitter<CycleSetupState> emit) {
    LocalStorageService.updateCycleLength(cycleLength);
    LocalStorageService.updateMenstruationLength(menstruationLength);
    emit(SavedCycleInformationState());
  }
}
