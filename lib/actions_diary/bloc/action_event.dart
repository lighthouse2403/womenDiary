import 'package:flutter/material.dart';
import 'package:women_diary/actions_diary/bloc/action_bloc.dart';

abstract class ActionHistoryEvent {}

class LoadActionHistoryEvent extends ActionHistoryEvent {}

class FilterActionHistoryEvent extends ActionHistoryEvent {
  final DateTimeRange? dateRange;
  final List<HistoryActionType> types;

  FilterActionHistoryEvent({this.dateRange, required this.types});
}
