import 'package:baby_diary/baby_action/bath/bath_model.dart';
import 'package:baby_diary/baby_action/bath/bloc/bath_event.dart';
import 'package:baby_diary/baby_action/bath/bloc/bath_state.dart';
import 'package:baby_diary/database/baby_action_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BathBloc extends Bloc<BathEvent, BathState> {
  List<BathModel> bathList =[];
  BathModel currentBath = BathModel.init();

  BathBloc() : super(const BathState()) {
    /// Bath detail
    on<InitBathDetailEvent>(_initBathDetail);
    on<DeleteBathEvent>(_deleteBath);
    on<SelectBabyEvent>(_changBaby);
    on<ChangedStartBathEvent>(_startBath);
    on<ChangedStopBathEvent>(_stopBath);
    on<ChangedNoteEvent>(_changedBathNote);
    on<SaveNewBathEvent>(_saveNewBath);
  }

  /// Bath detail
  Future<void> _changBaby(SelectBabyEvent event, Emitter emit) async {
    currentBath.babyId = event.baby.babyId;
    emit(UpdatedBathDetailState(currentBath));
  }

  Future<void> _initBathDetail(InitBathDetailEvent event, Emitter emit) async {
    currentBath = event.bath;
    emit(UpdatedBathDetailState(currentBath));
  }

  void _deleteBath(DeleteBathEvent event, Emitter emit) async {
    await BabyActionsDatabase.deleteActioon(event.bath.id);
    emit(const DeleteBathSuccessfulState());

  }

  void _startBath(ChangedStartBathEvent event, Emitter emit) async {
    currentBath.startTime = event.startTime;
  }

  void _stopBath(ChangedStopBathEvent event, Emitter emit) async {
    currentBath.stopTime = event.stopTime ??  DateTime.now();
    emit(const StopCountBathTimeState());
  }

  void _changedBathNote(ChangedNoteEvent event, Emitter emit) async {
    currentBath.note = event.note;
  }

  void _saveNewBath(SaveNewBathEvent event, Emitter emit) async {
  }
}
