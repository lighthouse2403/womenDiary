import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class ActionHistory extends StatelessWidget {
  const ActionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionBloc()..add(LoadActionEvent()),
      child: const _ActionHistoryView(),
    );
  }
}

class _ActionHistoryView extends StatefulWidget {
  const _ActionHistoryView();

  @override
  State<_ActionHistoryView> createState() => _ActionHistoryViewState();
}

class _ActionHistoryViewState extends State<_ActionHistoryView> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _filterChips(),
                Expanded(child: _buildList()),
              ],
            ),
            _addButton(context),
          ],
        ),
      ),
    );
  }

  Widget _filterChips() {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (pre, current) => current is ActionTypeUpdatedState,
      builder: (context, state) {
        ActionType? selectedType = state is ActionTypeUpdatedState ? state.type : null;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text(
                  "Tất cả",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                selected: selectedType == null,
                selectedColor: Colors.pink.shade100,
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: selectedType == null ? Colors.pink.shade700 : Colors.black87,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: selectedType == null ? Colors.pink.shade200 : Colors.grey.shade300,
                  ),
                ),
                visualDensity: VisualDensity.compact,
                onSelected: (_) {
                  context.read<ActionBloc>().add(UpdateActionTypeEvent(null));
                },
              ),
              ...ActionType.values.map(
                    (type) => ChoiceChip(
                  label: Text(
                    type.display,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  selected: selectedType == type,
                  selectedColor: Colors.pink.shade100,
                  backgroundColor: Colors.grey.shade100,
                  labelStyle: TextStyle(
                    color: selectedType == type ? Colors.pink.shade700 : Colors.black87,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: selectedType == type ? Colors.pink.shade200 : Colors.grey.shade300,
                    ),
                  ),
                  visualDensity: VisualDensity.compact,
                  onSelected: (_) {
                    context.read<ActionBloc>().add(UpdateActionTypeEvent(type));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList() {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (pre, current) => current is ActionLoadedState,
      builder: (context, state) {
        final List<ActionModel> actionList =
        (state is ActionLoadedState) ? state.actions : [];

        if (actionList.isEmpty) {
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

        final Map<String, List<ActionModel>> groupedByDate = {};
        for (var action in actionList) {
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
                ...entry.value.map((action) => _dismissibleCard(action, context)),
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

  Widget _dismissibleCard(ActionModel action, BuildContext context) {
    return Slidable(
      key: ValueKey(action.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) {
              showCupertinoDialog<bool>(
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
              );
            },
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xoá',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: _actionCard(action, context),
    );
  }

  Widget _actionCard(ActionModel action, BuildContext context) {
    String actionTime = DateFormat('HH:mm').format(action.time);
    return GestureDetector(
      onTap: () => context.navigateTo(RoutesName.actionDetail, arguments: action).then((value) {
        context.read<ActionBloc>().add(const LoadActionEvent());
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
            Text(action.emoji).text24(),
            Constants.hSpacer12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action.title)
                      .text16()
                      .w600()
                      .customColor(Colors.black87),
                  if (action.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(action.note)
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
