import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  /// Action list
  List<ActionModel> actions = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionType? type;
  List<CycleModel> cycleList = [];

  /// Action detail
  ActionModel actionDetail = ActionModel.init('', DateTime.now(), '', '');
  CycleModel cycle = CycleModel(DateTime.now());

  ActionBloc() : super(ActionHistoryLoading()) {
    on<LoadActionEvent>(_onLoadActions);
    on<UpdateActionTypeEvent>(_onUpdateActionType);
    on<UpdateDateRangeEvent>(_onUpdateDateRange);

    /// Action detail
    on<InitActionDetailEvent>(_onLoadActionDetail);
    on<DetectCycleEvent>(_onDetectCycle);
    on<UpdateEmojiEvent>(_onUpdateEmoji);
    on<UpdateTimeEvent>(_onUpdateTime);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<UpdateActionDetailEvent>(_onUpdateActionDetail);
    on<CreateActionDetailEvent>(_onCreateActionDetail);
    on<DeleteActionFromListEvent>(_onDeleteActionFromList);
    on<DeleteActionDetailEvent>(_onDeleteActionDetail);
  }

  Future<void> _onLoadActions(LoadActionEvent event, Emitter<ActionState> emit) async {
    cycleList = await DatabaseHandler.getAllCycle();
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: DateTime.now().millisecondsSinceEpoch,
        type: type
    );
    emit(ActionLoadedState(actions: actions));
  }

  void _onUpdateActionType(UpdateActionTypeEvent event, Emitter<ActionState> emit) async {
    type = event.actionType;
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );
    emit(ActionTypeUpdatedState(type: event.actionType));
    emit(ActionLoadedState(actions: actions));
  }

  void _onDetectCycle(DetectCycleEvent event, Emitter<ActionState> emit) async {
    cycle = await DatabaseHandler.getCycleByDate(event.actionTime) ?? cycle;
    emit(CycleDetectedState(cycle));
  }

  void _onUpdateDateRange(UpdateDateRangeEvent event, Emitter<ActionState> emit) async {
    startTime = event.startTime;
    endTime = event.endTime;
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );

    emit(ActionLoadedState(actions: actions));
  }

  void _onDeleteActionFromList(DeleteActionFromListEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    actions.removeWhere((action) => action.id == event.id);
    emit(ActionLoadedState(actions: actions));
  }

  /// --------------------------- Action Detail --------------------------------
  void _onLoadActionDetail(InitActionDetailEvent event, Emitter<ActionState> emit) async {
    actionDetail = event.initialAction;
    emit(EmojiUpdatedState(actionDetail.emoji));
    emit(TimeUpdatedState(actionDetail.time));
  }

  void _onUpdateActionDetail(UpdateActionDetailEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.updateAction(actionDetail);
    emit(ActionSavedSuccessfullyState());
  }

  void _onCreateActionDetail(CreateActionDetailEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.insertNewAction(actionDetail);
    emit(ActionSavedSuccessfullyState());
  }

  void _onDeleteActionDetail(DeleteActionDetailEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    actionDetail = ActionModel.init('', DateTime.now(), '', '');
    emit(ActionSavedSuccessfullyState());
  }

  void _onUpdateEmoji(UpdateEmojiEvent event, Emitter<ActionState> emit) async {
    actionDetail.emoji = event.emoji;
    emit(EmojiUpdatedState(event.emoji));
  }

  void _onUpdateTime(UpdateTimeEvent event, Emitter<ActionState> emit) async {
    actionDetail.time = event.time;
    emit(TimeUpdatedState(event.time));
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<ActionState> emit) async {
    actionDetail.title = event.title;
    emit(SaveButtonState(actionDetail.title.isNotEmpty));
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<ActionState> emit) async {
    actionDetail.note = event.note;
  }
}
