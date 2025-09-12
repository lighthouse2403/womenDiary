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
                    return _AnimatedScheduleCard(
                      schedule: schedule,
                      index: index,
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
        Text("Ngày $date")
            .text16()
            .w600()
            .customColor(Colors.pink.shade700),
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
              return context.read<ScheduleBloc>().add(const LoadScheduleEvent());
            }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.add, size: 20, color: Colors.white),
            Constants.hSpacer6,
            const Text("Thêm lịch")
                .text16()
                .w600()
                .customColor(Colors.white),
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

/// Card có animation fade + slide
class _AnimatedScheduleCard extends StatefulWidget {
  final ScheduleModel schedule;
  final int index;

  const _AnimatedScheduleCard({
    required this.schedule,
    required this.index,
  });

  @override
  State<_AnimatedScheduleCard> createState() => _AnimatedScheduleCardState();
}

class _AnimatedScheduleCardState extends State<_AnimatedScheduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + widget.index * 80),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: _ScheduleCard(schedule: widget.schedule),
      ),
    );
  }
}

/// Card lịch có switch nhắc nhở
class _ScheduleCard extends StatelessWidget {
  final ScheduleModel schedule;

  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final scheduleTime = DateFormat('HH:mm').format(schedule.time);

    return GestureDetector(
      onTap: () => context
          .navigateTo(RoutesName.scheduleDetail, arguments: schedule)
          .then((_) => context.read<ScheduleBloc>().add(const LoadScheduleEvent())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withAlpha(75),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(CupertinoIcons.heart_fill,
                size: 24, color: Colors.pinkAccent),
            const SizedBox(width: 12),

            // Nội dung
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule.title)
                      .text16()
                      .w600()
                      .customColor(Colors.black87),
                  if (schedule.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(schedule.note)
                          .text13()
                          .customColor(Colors.grey.shade600),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(CupertinoIcons.time,
                          size: 14, color: CupertinoColors.systemGrey),
                      const SizedBox(width: 4),
                      Text(scheduleTime)
                          .text13()
                          .customColor(Colors.grey.shade500),
                    ],
                  ),
                ],
              ),
            ),

            // Switch nhắc nhở
            CupertinoSwitch(
              value: schedule.isReminderOn,
              activeTrackColor: Colors.pinkAccent,
              onChanged: (val) {
                print('updated reminder: $val');
                context.read<ScheduleBloc>().add(
                  UpdateReminderOnListEvent(schedule),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
