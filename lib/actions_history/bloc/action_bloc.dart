import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/new_action.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionHistoryBloc extends Bloc<UserActionEvent, UserActionState> {
  /// Action list
  List<UserAction> actions = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionType? type;

  /// Action detail
  UserAction actionDetail = UserAction.init('', DateTime.now(), '', '');

  ActionHistoryBloc() : super(ActionHistoryLoading()) {
    on<LoadUserActionEvent>(_onLoadActions);
    on<UpdateActionTypeEvent>(_onUpdateActionType);
    on<UpdateDateRangeEvent>(_onUpdateDaterange);

    /// Action detail
    on<UpdateActionDetailEvent>(_onLoadActionDetail);
    on<UpdateEmojiEvent>(_onUpdateEmoji);
    on<UpdateTimeEvent>(_onUpdateTime);
    on<UpdateTitleEvent>(_onUpdateTitle);
    on<UpdateNoteEvent>(_onUpdateNote);
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

  void _onUpdateDaterange(UpdateDateRangeEvent event, Emitter<UserActionState> emit) async {
    startTime = event.startTime;
    endTime = event.endTime;
    actions = await DatabaseHandler.getActions(
        startTime: startTime.millisecondsSinceEpoch,
        endTime: endTime.millisecondsSinceEpoch,
        type: type
    );

    emit(UserActionLoadedState(actions: actions));
  }

  /// --------------------------- Action Detail --------------------------------
  void _onLoadActionDetail(UpdateActionDetailEvent event, Emitter<UserActionState> emit) async {
    actionDetail = event.initialAction;
    emit(ActionDetailUpdatedState(actionDetail));
  }

  void _onUpdateEmoji(UpdateEmojiEvent event, Emitter<UserActionState> emit) async {
    actionDetail.emoji = event.emoji;
  }

  void _onUpdateTime(UpdateTimeEvent event, Emitter<UserActionState> emit) async {
    actionDetail.time = event.time;
  }

  void _onUpdateTitle(UpdateTitleEvent event, Emitter<UserActionState> emit) async {
    actionDetail.title = event.title;
  }

  void _onUpdateNote(UpdateNoteEvent event, Emitter<UserActionState> emit) async {
    actionDetail.note = event.note;
  }
}
