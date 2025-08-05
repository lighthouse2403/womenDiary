import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_diary/bloc/action_event.dart';
import 'package:women_diary/actions_diary/bloc/action_state.dart';
import 'package:women_diary/actions_diary/new_action.dart';
import 'package:women_diary/actions_diary/user_action_model.dart';
import 'package:women_diary/database/data_handler.dart';

class ActionHistoryBloc extends Bloc<ActionHistoryEvent, ActionHistoryState> {
  List<UserAction> actions = [];
  DateTime startTime = DateTime.now().subtract(Duration(days: 90));
  DateTime endTime = DateTime.now();
  ActionType? type;

  ActionHistoryBloc() : super(ActionHistoryLoading()) {
    on<LoadActionsEvent>(_onLoadActions);
    on<FilterActions>(_onFilterActions);
  }

  Future<void> _onLoadActions(LoadActionsEvent event, Emitter<ActionHistoryState> emit) async {
    actions = await DatabaseHandler.getActions();
  }

  void _onFilterActions(FilterActions event, Emitter<ActionHistoryState> emit) {
    if (state is! ActionHistoryLoadedState) return;

    final current = (state as ActionHistoryLoadedState).groupedActions;
  }
}
