// history_state.dart
import 'package:flutter/material.dart';
import 'package:women_diary/actions_diary/bloc/action_bloc.dart';

class ActionHistoryState {
  final List<CycleHistoryItem> allItems;
  final List<CycleHistoryItem> filteredItems;
  final DateTimeRange? selectedRange;
  final List<HistoryActionType> selectedTypes;

  ActionHistoryState({
    required this.allItems,
    required this.filteredItems,
    this.selectedRange,
    required this.selectedTypes,
  });

  ActionHistoryState copyWith({
    List<CycleHistoryItem>? allItems,
    List<CycleHistoryItem>? filteredItems,
    DateTimeRange? selectedRange,
    List<HistoryActionType>? selectedTypes,
  }) {
    return ActionHistoryState(
      allItems: allItems ?? this.allItems,
      filteredItems: filteredItems ?? this.filteredItems,
      selectedRange: selectedRange ?? this.selectedRange,
      selectedTypes: selectedTypes ?? this.selectedTypes,
    );
  }
}
