import 'package:women_diary/actions_diary/action_history_filter.dart';

import 'action_history.dart';

class ActionHistoryFilterRepository {
  static final ActionHistoryFilterRepository _instance = ActionHistoryFilterRepository._internal();

  factory ActionHistoryFilterRepository() => _instance;

  ActionHistoryFilterRepository._internal();

  final List<ActionHistoryFilter> history = [];

  void addAction(ActionHistoryFilter action) {
    history.add(action);
  }
}
