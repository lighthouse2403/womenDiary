import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_diary/bloc/action_event.dart';
import 'package:women_diary/actions_diary/bloc/action_state.dart';
import 'package:women_diary/actions_diary/user_action_model.dart';

class ActionHistoryBloc extends Bloc<ActionHistoryEvent, ActionHistoryState> {
  ActionHistoryBloc() : super(ActionHistoryLoading()) {
    on<LoadActionsEvent>(_onLoadActions);
    on<FilterActions>(_onFilterActions);
  }

  Future<void> _onLoadActions(
      LoadActionsEvent event,
      Emitter<ActionHistoryState> emit,
      ) async {
    // TODO: Replace with actual data fetch
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    final grouped = {
      "Hôm nay": [
        UserAction.init("Uống thuốc", now.subtract(const Duration(hours: 1)), "💊", "Viên tránh thai"),
        UserAction.init( "Đau bụng", now.subtract(const Duration(hours: 3)), "🤕", "Cảm giác nhói"),
      ],
      "Hôm qua": [
        UserAction.init("Ra dịch", now.subtract(const Duration(days: 1, hours: 2)), "💧", "Không mùi"),
      ]
    };
  }

  void _onFilterActions(
      FilterActions event,
      Emitter<ActionHistoryState> emit,
      ) {
    if (state is! ActionHistoryLoadedState) return;

    final current = (state as ActionHistoryLoadedState).groupedActions;
  }
}
