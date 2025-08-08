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

class _ScheduleViewState extends State<_ScheduleView> {
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
        List<ScheduleModel> scheduleList = (state is ScheduleLoadedState) ? state.scheduleList : [];

        if (scheduleList.isEmpty) return _buildEmptyView();

        final groupedSchedules = _groupSchedulesByDate(scheduleList);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: groupedSchedules.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(entry.key),
                ...entry.value.map((schedule) => _buildDismissibleCard(schedule)),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Map<String, List<ScheduleModel>> _groupSchedulesByDate(List<ScheduleModel> schedules) {
    final Map<String, List<ScheduleModel>> grouped = {};
    for (var schedule in schedules) {
      final date = DateFormat('dd/MM/yyyy').format(schedule.time);
      grouped.putIfAbsent(date, () => []).add(schedule);
    }
    return grouped;
  }

  Widget _buildSectionHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text("📅 $date")
          .text16()
          .w600()
          .customColor(Colors.pink.shade600),
    );
  }

  Widget _buildDismissibleCard(ScheduleModel schedule) {
    return Dismissible(
      key: ValueKey(schedule.id),
      direction: DismissDirection.endToStart,
      background: _buildDeleteBackground(),
      confirmDismiss: (_) => _confirmDeleteDialog(),
      onDismissed: (_) {
        context.read<ScheduleBloc>().add(DeleteScheduleFromListEvent(schedule));
      },
      child: _buildScheduleCard(schedule),
    );
  }

  Widget _buildDeleteBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.redAccent.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(CupertinoIcons.delete, color: Colors.white),
    );
  }

  Future<bool> _confirmDeleteDialog() async {
    return await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Xoá bản ghi'),
        content: const Text('Bạn có chắc muốn xoá bản ghi này không?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Huỷ'),
            onPressed: () => Navigator.of(ctx).pop(false),
          ),
          CupertinoDialogAction(
            child: const Text('Xoá'),
            isDestructiveAction: true,
            onPressed: () => Navigator.of(ctx).pop(true),
          ),
        ],
      ),
    ) ??
        false;
  }

  Widget _buildScheduleCard(ScheduleModel schedule) {
    final scheduleTime = DateFormat('HH:mm').format(schedule.time);

    return GestureDetector(
      onTap: () => context
          .navigateTo(RoutesName.scheduleDetail, arguments: schedule)
          .then((_) => context.read<ScheduleBloc>().add(const LoadScheduleEvent())),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.pink.shade50,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withAlpha(50),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildScheduleContent(schedule),
            ),
            Constants.hSpacer10,
            _buildTime(scheduleTime),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleContent(ScheduleModel schedule) {
    return Column(
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
      ],
    );
  }

  Widget _buildTime(String scheduleTime) {
    return Row(
      children: [
        const Icon(CupertinoIcons.time, size: 14, color: CupertinoColors.systemGrey),
        const SizedBox(width: 4),
        Text(scheduleTime)
            .text12()
            .customColor(Colors.grey.shade500),
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.pinkAccent.shade100,
        borderRadius: BorderRadius.circular(30),
        onPressed: () => context.navigateTo(RoutesName.newSchedule).then((_) {
            return context.read<ScheduleBloc>().add(const LoadScheduleEvent());
        }),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.add, size: 20, color: Colors.white),
            Constants.hSpacer6,
            const Text("Thêm bản ghi")
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
          const Icon(CupertinoIcons.book, size: 80, color: Colors.pinkAccent),
          const SizedBox(height: 16),
          Text("Chưa có bản ghi nào")
              .text18()
              .w600()
              .customColor(Colors.pink.shade600),
          const SizedBox(height: 8),
          Text("Nhấn nút bên dưới để thêm bản ghi đầu tiên của bạn ❤️")
              .text14()
              .customColor(Colors.grey),
        ],
      ),
    );
  }
}
