import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionBloc extends Bloc<ActionEvent, ActionState> {
  /// Action list
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionTypeModel? type;
  List<CycleModel> cycleList = [];

  /// Action detail
  ActionModel actionDetail = ActionModel.init('', DateTime.now(), '', '');
  CycleModel cycle = CycleModel(DateTime.now());

  ActionBloc() : super(ActionHistoryLoading()) {
    on<LoadActionEvent>(_onLoadActions);
    on<UpdateActionTypeEvent>(_onUpdateActionType);
    on<LoadAllActionTypeEvent>(_onLoadActionType);

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
    List<ActionTypeModel> types = await DatabaseHandler.getAllActionType();
    print('load action ${type?.id}');

    List<ActionModel> actions = await DatabaseHandler.getActionsByType(typeId: type?.id);

    emit(ActionTypeUpdatedState(type: type, allType: types));
    emit(ActionLoadedState(actions: actions));

  }

  Future<void> _onLoadActionType(LoadAllActionTypeEvent event, Emitter<ActionState> emit) async {
    List<ActionTypeModel> types = await DatabaseHandler.getAllActionType();
    emit(ActionTypeUpdatedState(type: type, allType: types));
  }

  void _onUpdateActionType(UpdateActionTypeEvent event, Emitter<ActionState> emit) async {
    type = event.actionType;
    actionDetail.typeId = type?.id ?? '';
    List<ActionModel> actions = await DatabaseHandler.getActionsByType(typeId: type?.id);
    List<ActionTypeModel> types = await DatabaseHandler.getAllActionType();

    emit(ActionTypeUpdatedState(type: type, allType: types));
    emit(ActionLoadedState(actions: actions));
  }

  void _onDetectCycle(DetectCycleEvent event, Emitter<ActionState> emit) async {
    cycle = await DatabaseHandler.getCycleByDate(event.actionTime) ?? cycle;
    actionDetail.cycleId = cycle.id;
    emit(CycleDetectedState(cycle));
  }

  void _onDeleteActionFromList(DeleteActionFromListEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    List<ActionModel> actions = await DatabaseHandler.getActionsByType(typeId: type?.id);
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
    print('_onCreateActionDetail: ${actionDetail.toJson()}');
    await DatabaseHandler.insertNewAction(actionDetail);
    actionDetail = ActionModel.init('', DateTime.now(), '', '');


    emit(ActionSavedSuccessfullyState());
  }

  void _onDeleteActionDetail(DeleteActionDetailEvent event, Emitter<ActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    actionDetail = ActionModel.init('', DateTime.now(), '', '');
    List<ActionModel> actions = await DatabaseHandler.getActionsByType(typeId: type?.id);
    emit(ActionLoadedState(actions: actions));
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
