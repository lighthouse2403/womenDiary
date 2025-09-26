import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/cycle/first_setup/bloc/cycle_setup_event.dart';
import 'package:women_diary/cycle/first_setup/bloc/cycle_setup_state.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleSetupBloc extends Bloc<CycleSetupEvent, CycleSetupState> {
  int cycleLength = 30;
  int menstruationLength = 6;
  DateTime lastPeriodDate = DateTime.now().subtract(Duration(days: 6));

  CycleSetupBloc() : super(CycleSetupState()) {
    on<CycleLengthChangedEvent>(_onChangingCycleLength);
    on<MenstruationLengthChangedEvent>(_onChangingMenstruationLength);
    on<SubmitCycleInformationEvent>(_submitCycleInformation);
    on<LastPeriodDateChangedEvent>(_onChangingLastPeriodDate);
  }

  void _onChangingCycleLength(CycleLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    cycleLength = event.cycleLength;
    emit(UpdatedCycleLengthState(cycleLength));
  }

  void _onChangingMenstruationLength(MenstruationLengthChangedEvent event, Emitter<CycleSetupState> emit) {
    menstruationLength = event.menstruationLength;
    emit(UpdatedMenstruationLengthState(menstruationLength));
  }

  void _onChangingLastPeriodDate(LastPeriodDateChangedEvent event, Emitter<CycleSetupState> emit) {
    lastPeriodDate = event.date;
    emit(UpdatedLastPeriodDateState(lastPeriodDate));
  }

  Future<void> _submitCycleInformation(SubmitCycleInformationEvent event, Emitter<CycleSetupState> emit) async {
    await LocalStorageService.updateCycleLength(cycleLength);
    await LocalStorageService.updateMenstruationLength(menstruationLength);

    CycleModel cycle = CycleModel.init(
        lastPeriodDate,
        lastPeriodDate.add(Duration(days: cycleLength - 1)),
        lastPeriodDate.add(Duration(days: menstruationLength - 1))
    );
    await DatabaseHandler.insertCycle(cycle);
    emit(SavedCycleInformationState());
  }
}
