import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/schedule/bloc/schedule_bloc.dart';
import 'package:women_diary/schedule/bloc/schedule_event.dart';
import 'package:women_diary/schedule/bloc/schedule_state.dart';
import 'package:women_diary/schedule/schedule_list/animated_schedule_card.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class Schedule extends StatelessWidget {
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleBloc()..add(const LoadScheduleEvent()),
      child: const _ScheduleView(),
    );
  }
}

class _ScheduleView extends StatefulWidget {
  const _ScheduleView();

  @override
  State<_ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<_ScheduleView>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            _buildScheduleList(),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      buildWhen: (prev, current) => current is ScheduleLoadedState,
      builder: (context, state) {
        List<ScheduleModel> scheduleList =
        (state is ScheduleLoadedState) ? state.scheduleList : [];

        if (scheduleList.isEmpty) return _buildEmptyView();

        final groupedSchedules = _groupSchedulesByDate(scheduleList);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: groupedSchedules.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(entry.key),
                const SizedBox(height: 8),
                ...entry.value.asMap().entries.map(
                      (e) {
                    final index = e.key;
                    final schedule = e.value;

                    return Dismissible(
                      key: ValueKey(schedule.id), // id duy nhất
                      direction: DismissDirection.endToStart,
                      background: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerRight,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          CupertinoIcons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (_) {
                        // gửi event xoá vào bloc
                        context
                            .read<ScheduleBloc>()
                            .add(DeleteScheduleFromListEvent(schedule));
                      },
                      child: AnimatedScheduleCard(
                        schedule: schedule,
                        index: index,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Map<String, List<ScheduleModel>> _groupSchedulesByDate(
      List<ScheduleModel> schedules) {
    final Map<String, List<ScheduleModel>> grouped = {};
    for (var schedule in schedules) {
      final date = DateFormat('dd/MM/yyyy').format(schedule.time);
      grouped.putIfAbsent(date, () => []).add(schedule);
    }
    return grouped;
  }

  Widget _buildSectionHeader(String date) {
    return Row(
      children: [
        const Icon(CupertinoIcons.calendar_today,
            size: 20, color: Colors.pinkAccent),
        const SizedBox(width: 6),
        Text("Ngày $date").text16().w600().customColor(Colors.pink.shade700),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.pinkAccent.shade200,
        borderRadius: BorderRadius.circular(30),
        onPressed: () =>
            context.navigateTo(RoutesName.newSchedule).then((_) {
              return context.read<ScheduleBloc>().add(
                  const LoadScheduleEvent());
            }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.add, size: 20, color: Colors.white),
            Constants.hSpacer6,
            const Text("Thêm kế hoạch").text16().w600().whiteColor()
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(CupertinoIcons.heart_circle_fill,
              size: 90, color: Colors.pinkAccent),
          const SizedBox(height: 16),
          Text("Chưa có lịch nào")
              .text18()
              .w600()
              .customColor(Colors.pink.shade600),
          const SizedBox(height: 8),
          Text("Nhấn nút + để thêm lịch đầu tiên cho bạn 🌸")
              .text14()
              .customColor(Colors.grey),
        ],
      ),
    );
  }
}
