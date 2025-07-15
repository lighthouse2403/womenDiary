import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/baby_action/eating/bloc/eating_event.dart';
import 'package:baby_diary/baby_action/eating/bloc/eating_state.dart';
import 'package:baby_diary/baby_action/eating/eating_model.dart';
import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/database/baby_action_database.dart';
import 'package:baby_diary/database/data_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EatingBloc extends Bloc<EatingEvent, EatingState> {
  List<EatingModel> eatingList =[];
  BabyActionModel currentEating = BabyActionModel.init(ActionType.eating);

  EatingBloc() : super(const EatingState()) {
    on<ChangedBabyEvent>(_changedBaby);
    on<InitEatingDetailEvent>(_initEatingDetail);
    on<ChangedQuantityEvent>(_changedQuantity);
    on<ChangedBabyEvent>(_changedBaby);
    on<ChangedStopTimeEvent>(_changedStopTime);
    on<ChangedStartTimeEvent>(_changedStartTime);
    on<ChangedUnitEvent>(_changedUnit);
    on<ChangedNoteEvent>(_changedNote);
    on<CreateNewEatingEvent>(_createNewEating);
    on<UpdateEatingEvent>(_updatedEating);
    on<DeleteEatingEvent>(_deleteEating);
  }

  Future<void> _initEatingDetail(InitEatingDetailEvent event, Emitter emit) async {
    List<BabyModel> babies = await DatabaseHandler.getAllBaby();
    currentEating.babyId = babies.firstOrNull?.babyId ?? '';
    currentEating = event.eating ?? currentEating;
  }

  /// Update property of eating
  void _changedBaby(ChangedBabyEvent event, Emitter emit) async {
    currentEating.babyId = event.baby.babyId;
  }

  void _changedQuantity(ChangedQuantityEvent event, Emitter emit) async {
    currentEating.value = '${event.quantity}';
  }

  void _changedStopTime(ChangedStopTimeEvent event, Emitter emit) async {
    currentEating.stopTime = event.stopTime;
  }

  void _changedStartTime(ChangedStartTimeEvent event, Emitter emit) async {
    currentEating.startTime = event.startTime;
  }

  void _changedUnit(ChangedUnitEvent event, Emitter emit) async {
    currentEating.unit = event.unit;
  }

  void _changedNote(ChangedNoteEvent event, Emitter emit) async {
    currentEating.note = event.note;
  }

  /// Update eating to database
  void _createNewEating(CreateNewEatingEvent event, Emitter emit) async {
    BabyActionsDatabase.insert(currentEating);
    emit(const SaveEatingSuccessfulState());
  }

  void _updatedEating(UpdateEatingEvent event, Emitter emit) async {
    BabyActionsDatabase.updateAction(currentEating);
    emit(const SaveEatingSuccessfulState());
  }

  void _deleteEating(DeleteEatingEvent event, Emitter emit) async {
    BabyActionsDatabase.deleteActioon(currentEating.id);
    emit(const SaveEatingSuccessfulState());
  }
}
