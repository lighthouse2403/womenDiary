import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/widgets/date_picker/multi_range_calendar.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';

class CycleCalendar extends StatelessWidget {
  const CycleCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()..add(LoadAllCycleEvent()),
      child: const _CycleCalendarView(),
    );
  }
}

class _CycleCalendarView extends StatefulWidget {
  const _CycleCalendarView();

  @override
  State<_CycleCalendarView> createState() => _CycleCalendarViewState();
}

class _CycleCalendarViewState extends State<_CycleCalendarView> {

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CycleBloc, CycleState>(
      builder: (context, state) {
        List<CycleModel> cycles = state is LoadedAllCycleState ? state.cycleList : [];

        return MultiRangeCalendar(
          initialRanges: cycles,
          onAddRange: (range) {
            context.read<CycleBloc>().add(CreateCycleEvent(range));
          },
          onDeleteRange: (rangeId) {
            context.read<CycleBloc>().add(DeleteCycleEvent(rangeId));
          },
        );
        },
    );
  }
}
