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
      create: (_) => ActionBloc()..add(const LoadActionEvent()),
      child: const _ActionHistoryView(),
    );
  }
}

class _ActionHistoryView extends StatelessWidget {
  const _ActionHistoryView();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: const [
                _FilterChips(),
                Expanded(child: _ActionList()),
              ],
            ),
            const _AddButton(),
          ],
        ),
      ),
    );
  }
}

/// ---------------- Filter Chips ----------------
class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ActionBloc, ActionState, ActionType?>(
      selector: (state) =>
      state is ActionTypeUpdatedState ? state.type : null,
      builder: (context, selectedType) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 8,
            children: [
              _chip(
                context,
                label: "Tất cả",
                selected: selectedType == null,
                onTap: () =>
                    context.read<ActionBloc>().add(UpdateActionTypeEvent(null)),
              ),
              ...ActionType.values.map((type) => _chip(
                context,
                label: type.display,
                selected: selectedType == type,
                onTap: () => context
                    .read<ActionBloc>()
                    .add(UpdateActionTypeEvent(type)),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(BuildContext context,
      {required String label,
        required bool selected,
        required VoidCallback onTap}) {
    return ChoiceChip(
      label: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      selected: selected,
      selectedColor: Colors.pink.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: selected ? Colors.pink.shade700 : Colors.black87,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? Colors.pink.shade200 : Colors.grey.shade300,
        ),
      ),
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onTap(),
    );
  }
}

/// ---------------- Action List ----------------
class _ActionList extends StatelessWidget {
  const _ActionList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (_, state) => state is ActionLoadedState,
      builder: (context, state) {
        final actions =
        (state is ActionLoadedState) ? state.actions : <ActionModel>[];

        if (actions.isEmpty) return const _EmptyState();

        final groupedByDate = <String, List<ActionModel>>{};
        for (final action in actions) {
          final date = DateFormat('dd/MM/yyyy').format(action.time);
          groupedByDate.putIfAbsent(date, () => []).add(action);
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: groupedByDate.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(date: entry.key),
                ...entry.value.map((a) => _ActionCard(action: a)),
                const SizedBox(height: 20),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
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

class _SectionHeader extends StatelessWidget {
  final String date;
  const _SectionHeader({required this.date});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
      Text("📅 $date").text16().w600().customColor(Colors.pink.shade600),
    );
  }
}

/// ---------------- Action Card ----------------
class _ActionCard extends StatelessWidget {
  final ActionModel action;
  const _ActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(action.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => _confirmDelete(context),
            backgroundColor: Colors.redAccent,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: 'Xoá',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () => context
            .navigateTo(RoutesName.actionDetail, arguments: action)
            .then((_) => context.read<ActionBloc>().add(const LoadActionEvent())),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade100.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.pink.shade100.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(action.emoji, style: const TextStyle(fontSize: 24)),
              ),
              Constants.hSpacer12,

              // Nội dung
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
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          action.note,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Thời gian
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  DateFormat('HH:mm').format(action.time),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
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
            onPressed: () {
              Navigator.of(ctx).pop(true);
              context.read<ActionBloc>().add(DeleteActionDetailEvent(action.id));
            },
          ),
        ],
      ),
    );
  }
}

/// ---------------- Floating Add Button ----------------
class _AddButton extends StatelessWidget {
  const _AddButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: Colors.pinkAccent.shade100,
        borderRadius: BorderRadius.circular(30),
        onPressed: () => context
            .navigateTo(RoutesName.newAction)
            .then((_) => context.read<ActionBloc>().add(const LoadActionEvent())),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.add, size: 20, color: Colors.white),
            Constants.hSpacer6,
            const Text("Thêm bản ghi").text16().w600().whiteColor(),
          ],
        ),
      ),
    );
  }
}
