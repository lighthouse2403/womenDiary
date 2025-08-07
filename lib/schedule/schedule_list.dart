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
            Column(
              children: [
                Expanded(child: _buildList()),
              ],
            ),
            _addButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      buildWhen: (pre, current) => current is ScheduleLoadedState,
      builder: (context, state) {
        final List<ScheduleModel> scheduleList =
        (state is ScheduleLoadedState) ? state.scheduleList : [];

        if (scheduleList.isEmpty) {
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

        final Map<String, List<ScheduleModel>> groupedByDate = {};
        for (var action in scheduleList) {
          final date = DateFormat('dd/MM/yyyy').format(action.time);
          groupedByDate.putIfAbsent(date, () => []).add(action);
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: groupedByDate.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionHeader(entry.key),
                ...entry.value.map((shedule) => _dismissibleCard(shedule, context)),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      },
    );
  }

  Widget _sectionHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text("📅 $date")
          .text16()
          .w600()
          .customColor(Colors.pink.shade600),
    );
  }

  Widget _dismissibleCard(ScheduleModel shedule, BuildContext context) {
    return Dismissible(
      key: ValueKey(shedule.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent.shade100,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(CupertinoIcons.delete, color: Colors.white),
      ),
      confirmDismiss: (_) async {
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
      },
      onDismissed: (_) {
        context.read<ScheduleBloc>().add(DeleteScheduleFromListEvent(shedule.id));
      },
      child: _actionCard(shedule, context),
    );
  }

  Widget _actionCard(ScheduleModel shedule, BuildContext context) {
    String actionTime = DateFormat('HH:mm').format(shedule.time);
    return GestureDetector(
      onTap: () => context.navigateTo(RoutesName.actionDetail, arguments: shedule).then((value) {
        context.read<ScheduleBloc>().add(const LoadScheduleEvent());
      }),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(shedule.title)
                      .text16()
                      .w600()
                      .customColor(Colors.black87),
                  if (shedule.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(shedule.note)
                          .text13()
                          .customColor(Colors.grey.shade600),
                    ),
                ],
              ),
            ),
            Constants.hSpacer10,
            Row(
              children: [
                const Icon(CupertinoIcons.time, size: 14, color: CupertinoColors.systemGrey),
                const SizedBox(width: 4),
                Text(actionTime)
                    .text12()
                    .customColor(Colors.grey.shade500),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _addButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.pinkAccent.shade100,
        borderRadius: BorderRadius.circular(30),
        onPressed: () => context.navigateTo(RoutesName.newAction),
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
}
