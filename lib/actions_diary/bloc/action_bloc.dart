// history_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_diary/bloc/action_event.dart';
import 'package:women_diary/actions_diary/bloc/action_state.dart';

enum HistoryActionType { medicine, pain, bleeding, note }

class CycleHistoryItem {
  final DateTime date;
  final HistoryActionType type;
  final String description;

  CycleHistoryItem({
    required this.date,
    required this.type,
    required this.description,
  });
}

class ActionHistoryBloc extends Bloc<ActionHistoryEvent, ActionHistoryState> {
  ActionHistoryBloc()
      : super(ActionHistoryState(
    allItems: [],
    filteredItems: [],
    selectedTypes: HistoryActionType.values,
  )) {
    on<LoadActionHistoryEvent>(_onLoad);
    on<FilterActionHistoryEvent>(_onFilter);
  }

  void _onLoad(LoadActionHistoryEvent event, Emitter<ActionHistoryState> emit) {
    final mockData = [
      CycleHistoryItem(
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: HistoryActionType.medicine,
        description: "Uống thuốc giảm đau",
      ),
      CycleHistoryItem(
        date: DateTime.now().subtract(const Duration(days: 2)),
        type: HistoryActionType.pain,
        description: "Đau bụng nhẹ",
      ),
      CycleHistoryItem(
        date: DateTime.now().subtract(const Duration(days: 4)),
        type: HistoryActionType.bleeding,
        description: "Ra máu ít",
      ),
    ];

    emit(state.copyWith(allItems: mockData, filteredItems: mockData));
  }

  void _onFilter(FilterActionHistoryEvent event, Emitter<ActionHistoryState> emit) {
    final filtered = state.allItems.where((item) {
      final inType = event.types.contains(item.type);
      final inRange = event.dateRange == null ||
          (item.date.isAfter(event.dateRange!.start.subtract(const Duration(days: 1))) &&
              item.date.isBefore(event.dateRange!.end.add(const Duration(days: 1))));
      return inType && inRange;
    }).toList();

    emit(state.copyWith(
      filteredItems: filtered,
      selectedRange: event.dateRange,
      selectedTypes: event.types,
    ));
  }
}
