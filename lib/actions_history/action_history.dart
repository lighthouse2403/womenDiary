import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/new_action.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class ActionHistory extends StatelessWidget {
  const ActionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionHistoryBloc()..add(LoadUserActionEvent()),
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
      navigationBar: const CupertinoNavigationBar(
        middle: Text("📖 Lịch sử hành động"),
      ),
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
    return BlocBuilder<ActionHistoryBloc, UserActionState>(
      buildWhen:  (pre, current) => current is ActionTypeUpdatedState,
        builder: (context, state) {
        ActionType? selectedType = state is ActionTypeUpdatedState ? state.type : null;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text("Tất cả"),
                  selected: selectedType == null,
                  onSelected: (_) {
                    context.read<ActionHistoryBloc>().add(UpdateActionTypeEvent(null));
                  },
                ),
                ...ActionType.values.map(
                      (type) => ChoiceChip(
                    label: Text(type.display),
                    selected: selectedType == type,
                    onSelected: (_) {
                      context.read<ActionHistoryBloc>().add(UpdateActionTypeEvent(type));
                    },
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  Widget _buildList() {
    return BlocBuilder<ActionHistoryBloc, UserActionState>(
      buildWhen: (pre, current) => current is UserActionLoadedState,
      builder: (context, state) {
        List<UserAction> actionList = (state is UserActionLoadedState) ? state.actions : [];
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          itemCount: actionList.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...actionList.map((action) => _actionCard(action, context)),
              ],
            );
          },
        );
      },
    );
  }

  Widget _addButton(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: CupertinoButton.filled(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        borderRadius: BorderRadius.circular(30),
        onPressed: () {
          context.navigateTo(RoutesName.newAction);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.add, size: 20, color: CupertinoColors.white),
            Constants.hSpacer6,
            const Text("Thêm bản ghi").whiteColor(),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(title).text16().w600().pinkColor(),
    );
  }

  Widget _actionCard(UserAction action, BuildContext context) {
    String actionTime = DateFormat('HH:mm').format(action.time);
    return GestureDetector(
      onTap: () => context.navigateTo(RoutesName.actionDetail, arguments: action),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(action.emoji).text20(),
            Constants.hSpacer12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(action.title).text16().w600(),
                  if (action.note.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(action.note).text14().customColor(CupertinoColors.systemGrey),
                    ),
                ],
              ),
            ),
            Constants.hSpacer10,
            Text(actionTime).text12().customColor(CupertinoColors.systemGrey2),
          ],
        ),
      ),
    );
  }
}
