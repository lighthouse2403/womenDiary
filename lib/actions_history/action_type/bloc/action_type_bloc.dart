import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_event.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionTypeBloc extends Bloc<ActionTypeEvent, ActionTypeState> {

  ActionTypeModel typeDetail = ActionTypeModel.init('', '');

  ActionTypeBloc() : super(ActionTypeState()) {
    on<LoadActionTypeEvent>(_onLoadActionTypes);
    on<InitActionTypeDetailEvent>(_onInitActionType);

    /// Action detail
    on<UpdateEmojiTypeEvent>(_onUpdatedEmoji);
    on<UpdateTitleTypeEvent>(_onUpdatedTitle);
    
    on<UpdateActionTypeDetailEvent>(_onUpdatedActionType);
    on<CreateActionTypeDetailEvent>(_onCreateActionType);
  }

  Future<void> _onLoadActionTypes(LoadActionTypeEvent event, Emitter<ActionTypeState> emit) async {
    List<ActionTypeModel> actionTypes = await DatabaseHandler.getAllActionType();
    emit(ActionTypeLoadedState(actionTypes: actionTypes));
  }

  void _onInitActionType(InitActionTypeDetailEvent event, Emitter<ActionTypeState> emit) async {
    typeDetail = event.initialActionType;
    emit(ActionTypeUpdatedState(typeDetail));
  }

  void _onUpdatedEmoji(UpdateEmojiTypeEvent event, Emitter<ActionTypeState> emit) async {
    typeDetail.emoji = event.emoji;
  }

  void _onUpdatedTitle(UpdateTitleTypeEvent event, Emitter<ActionTypeState> emit) async {
    typeDetail.title = event.title;
  }

  void _onUpdatedActionType(UpdateActionTypeDetailEvent event, Emitter<ActionTypeState> emit) async {
    await DatabaseHandler.updateActionType(typeDetail);
    emit(ActionTypeSavedSuccessfullyState());
  }

  void _onCreateActionType(CreateActionTypeDetailEvent event, Emitter<ActionTypeState> emit) async {
    await DatabaseHandler.insertNewActionType(typeDetail);
    emit(ActionTypeSavedSuccessfullyState());
  }
}
