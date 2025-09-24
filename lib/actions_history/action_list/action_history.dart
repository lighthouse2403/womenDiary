import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/actions_history/action_list/component/action_row.dart';
import 'package:women_diary/actions_history/action_list/component/filter_chips.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
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
    return Scaffold(
      appBar: BaseAppBar(
        backgroundColor: Colors.pink[200],
        hasBack: true,
        title: 'Hành động',
        actions: [
          InkWell(
            onTap: () {
              context.navigateTo(RoutesName.actionType);
            },
            child: Assets.icons.setting.svg(width: 14, height: 14),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                FilterChips(),
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
                ...entry.value.map((a) => ActionRow(action: a)),
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
          Constants.vSpacer12,
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
