import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_event.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionTypeBloc extends Bloc<ActionTypeEvent, ActionTypeState> {

  ActionTypeBloc() : super(ActionTypeState()) {
    on<LoadActionTypeEvent>(_onLoadActionTypes);

    on<DeleteActionTypeEvent>(_onDeletedActionType);
    on<UpdateActionTypeDetailEvent>(_onUpdatedActionType);
    on<CreateActionTypeDetailEvent>(_onCreateActionType);
  }

  Future<void> _onLoadActionTypes(LoadActionTypeEvent event, Emitter<ActionTypeState> emit) async {
    List<ActionTypeModel> actionTypes = await DatabaseHandler.getAllActionType();
    emit(ActionTypeLoadedState(actionTypes: actionTypes));
  }

  void _onDeletedActionType(DeleteActionTypeEvent event, Emitter<ActionTypeState> emit) async {
    await DatabaseHandler.deleteActionType(event.id);
    List<ActionTypeModel> actionTypes = await DatabaseHandler.getAllActionType();
    emit(ActionTypeLoadedState(actionTypes: actionTypes));
  }

  void _onUpdatedActionType(UpdateActionTypeDetailEvent event, Emitter<ActionTypeState> emit) async {
    ActionTypeModel actionType = ActionTypeModel(id: event.id, title: event.title, emoji: event.emoji);
    await DatabaseHandler.updateActionType(actionType);

    print('updateActionType: ${actionType.toJson()}');

    List<ActionTypeModel> actionTypes = await DatabaseHandler.getAllActionType();
    print('updateActionType: ${actionTypes.map((e) => e.toJson())}');

    emit(ActionTypeLoadedState(actionTypes: actionTypes));
  }

  void _onCreateActionType(CreateActionTypeDetailEvent event, Emitter<ActionTypeState> emit) async {
    ActionTypeModel newActionType = ActionTypeModel.init(event.title, event.emoji);
    await DatabaseHandler.insertNewActionType(newActionType);

    List<ActionTypeModel> actionTypes = await DatabaseHandler.getAllActionType();
    emit(ActionTypeLoadedState(actionTypes: actionTypes));
  }
}
