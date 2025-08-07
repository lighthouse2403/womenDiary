import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/database/data_handler.dart';

class UserActionBloc extends Bloc<UserActionEvent, UserActionState> {
  /// Action list
  List<UserAction> actions = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionType? type;

  /// Action detail
  UserAction actionDetail = UserAction.init('', DateTime.now(), '', '');

  UserActionBloc() : super(ActionHistoryLoading()) {
    on<LoadUserActionEvent>(_onLoadActions);
    on<UpdateActionTypeEvent>(_onUpdateActionType);
    on<UpdateDateRangeEvent>(_onUpdateDateRange);

    /// Action detail
    on<InitActionDetailEvent>(_onLoadActionDetail);
    on<UpdateEmojiEvent>(_onUpdateEmoji);
    on<UpdateTimeEvent>(_onUpdateTime);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<UpdateNoteEvent>(_onUpdateNote);
    on<UpdateActionDetailEvent>(_onUpdateActionDetail);
    on<CreateActionDetailEvent>(_onCreateActionDetail);
    on<DeleteActionFromListEvent>(_onDeleteActionFromList);
    on<DeleteActionDetailEvent>(_onDeleteActionDetail);
  }

  Future<void> _onLoadActions(LoadUserActionEvent event, Emitter<UserActionState> emit) async {
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );
    emit(UserActionLoadedState(actions: actions));
  }

  void _onUpdateActionType(UpdateActionTypeEvent event, Emitter<UserActionState> emit) async {
    type = event.actionType;
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );
    emit(ActionTypeUpdatedState(type: event.actionType));
    emit(UserActionLoadedState(actions: actions));
  }

  void _onUpdateDateRange(UpdateDateRangeEvent event, Emitter<UserActionState> emit) async {
    startTime = event.startTime;
    endTime = event.endTime;
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );

    emit(UserActionLoadedState(actions: actions));
  }

  void _onDeleteActionFromList(DeleteActionFromListEvent event, Emitter<UserActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    actions.removeWhere((action) => action.id == event.id);
    emit(UserActionLoadedState(actions: actions));
  }
  
  /// --------------------------- Action Detail --------------------------------
  void _onLoadActionDetail(InitActionDetailEvent event, Emitter<UserActionState> emit) async {
    actionDetail = event.initialAction;
    emit(EmojiUpdatedState(actionDetail.emoji));
    emit(TimeUpdatedState(actionDetail.time));
  }

  void _onUpdateActionDetail(UpdateActionDetailEvent event, Emitter<UserActionState> emit) async {
    await DatabaseHandler.updateAction(actionDetail);
    emit(ActionSavedSuccessfullyState());
  }

  void _onCreateActionDetail(CreateActionDetailEvent event, Emitter<UserActionState> emit) async {
    await DatabaseHandler.insertNewAction(actionDetail);
    emit(ActionSavedSuccessfullyState());
  }

  void _onDeleteActionDetail(DeleteActionDetailEvent event, Emitter<UserActionState> emit) async {
    await DatabaseHandler.deleteAction(event.id);
    actionDetail = UserAction.init('', DateTime.now(), '', '');
    emit(ActionSavedSuccessfullyState());
  }

  void _onUpdateEmoji(UpdateEmojiEvent event, Emitter<UserActionState> emit) async {
    actionDetail.emoji = event.emoji;
    emit(EmojiUpdatedState(event.emoji));
  }

  void _onUpdateTime(UpdateTimeEvent event, Emitter<UserActionState> emit) async {
    actionDetail.time = event.time;
    emit(TimeUpdatedState(event.time));
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<UserActionState> emit) async {
    actionDetail.title = event.title;
    emit(SaveButtonState(actionDetail.title.isNotEmpty));
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<UserActionState> emit) async {
    actionDetail.note = event.note;
  }
}
