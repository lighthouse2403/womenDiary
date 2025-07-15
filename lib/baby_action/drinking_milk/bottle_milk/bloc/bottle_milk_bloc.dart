import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_action/drinking_milk/bottle_milk/bloc/bottle_milk_event.dart';
import 'package:baby_diary/baby_action/drinking_milk/bottle_milk/bloc/bottle_milk_state.dart';
import 'package:baby_diary/baby_action/drinking_milk/bottle_milk/bottle_milk_list/bottle_milk_model.dart';
import 'package:baby_diary/database/baby_action_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottleMilkBloc extends Bloc<BottleMilkEvent, BottleMilkState> {
  List<BabyActionModel> bottleMilkList =[];
  BabyActionModel currentBottleMilk = BabyActionModel.init(ActionType.bottleMilk);

  BottleMilkBloc() : super(const BottleMilkState()) {
    on<ChangeBabyEvent>(_changBaby);
    on<InitBottleMilkDetailEvent>(_initBottleMilkDetail);
    on<DeleteBottleMilkEvent>(_deleteBottleMilk);
    on<ChangedBottleMilkStartTimeEvent>(_changedBottleMilkStartTime);
    on<ChangedBottleMilkStopTimeEvent>(_changedBottleMilkStopTime);
    on<ChangedNoteEvent>(_changedBottleMilkNote);
    on<SaveNewBottleMilkEvent>(_saveNewBottleMilk);
  }

  /// Bottle Milk detail
  Future<void> _changBaby(ChangeBabyEvent event, Emitter emit) async {
    currentBottleMilk.babyId = event.baby.babyId;
    emit(ChangedBabyState(event.baby));
  }

  Future<void> _initBottleMilkDetail(InitBottleMilkDetailEvent event, Emitter emit) async {
    currentBottleMilk = event.bottleMilk;
  }

  void _deleteBottleMilk(DeleteBottleMilkEvent event, Emitter emit) async {
    await BabyActionsDatabase.deleteActioon(event.bottleMilk.id);
    emit(const DeleteBottleMilkSuccessfulState());

  }

  void _changedBottleMilkStartTime(ChangedBottleMilkStartTimeEvent event, Emitter emit) async {
    currentBottleMilk.startTime = event.startTime;
    emit(ChangedBottleStartTimeState(event.startTime));
  }

  void _changedBottleMilkStopTime(ChangedBottleMilkStopTimeEvent event, Emitter emit) async {
    currentBottleMilk.stopTime = event.stopTime;
    emit(ChangedBottleStopTimeState(event.stopTime));
  }

  void _changedBottleMilkNote(ChangedNoteEvent event, Emitter emit) async {
    currentBottleMilk.note = event.note;
  }

  void _saveNewBottleMilk(SaveNewBottleMilkEvent event, Emitter emit) async {
    await BabyActionsDatabase.insert(currentBottleMilk);
    emit(const SaveBottleMilkSuccessfulState());
  }
}
