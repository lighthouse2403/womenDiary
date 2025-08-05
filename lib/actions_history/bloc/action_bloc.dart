import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/new_action.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionHistoryBloc extends Bloc<UserActionEvent, UserActionState> {
  List<UserAction> actions = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionType? type;

  ActionHistoryBloc() : super(ActionHistoryLoading()) {
    on<LoadUserActionEvent>(_onLoadActions);
    on<UpdateActionTypeEvent>(_onUpdateActionType);
    on<UpdateDateRangeEvent>(_onUpdateDaterange);

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
    emit(ActionTypeUpdatedState(type: type));
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
}
