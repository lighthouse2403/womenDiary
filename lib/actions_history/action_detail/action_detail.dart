import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ActionDetail extends StatelessWidget {
  const ActionDetail({super.key, required this.action});
  final ActionModel action;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionBloc()
        ..add(InitActionDetailEvent(action))
        ..add(DetectCycleEvent(action.time)),
      child: _ActionDetailView(action: action),
    );
  }
}

class _ActionDetailView extends StatelessWidget {
  const _ActionDetailView({required this.action});
  final ActionModel action;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionBloc, ActionState>(
      listenWhen: (_, curr) =>
      curr is ActionSavedSuccessfullyState ||
          curr is ActionDeletedState,
      listener: (context, state) async {
        if (state is ActionSavedSuccessfullyState) {
          await _showDialog(context, "Thành công!", "Hành động đã được cập nhật.");
        }
        if (state is ActionDeletedState) {
          await _showDialog(context, "Đã xoá!", "Hành động đã bị xoá.");
        }
      },
      child: _mainScaffold(context),
    );
  }

  Widget _mainScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: BaseAppBar(
        title: "Chi tiết hành động",
        backgroundColor: Colors.pink.shade300,
        hasBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(child: _timePicker()),
            _cycleInfo(),
            Constants.vSpacer16,
            _buildCard(child: _emoji()),
            Constants.vSpacer16,
            _buildCard(child: _actionType()),
            Constants.vSpacer16,
            _buildCard(child: _titleInput(context)),
            Constants.vSpacer16,
            _buildCard(child: _noteInput(context)),
            Constants.vSpacer24,
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
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
      child: child,
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title).text18().w600().pinkColor(),
  );

  Widget _timePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Thời gian"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (_, curr) => curr is TimeUpdatedState,
          builder: (context, state) {
            DateTime time =
            state is TimeUpdatedState ? state.time : action.time;
            return InkWell(
              onTap: () => _pickDateTime(context, time),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.pink),
                    Constants.hSpacer8,
                    Text(time.globalDateTimeFormat()).text16().w500(),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _pickDateTime(BuildContext context, DateTime initial) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
    );
    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (pickedTime == null) return;

    final result = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    final bloc = context.read<ActionBloc>();
    bloc.add(UpdateTimeEvent(result));
    bloc.add(DetectCycleEvent(result));
  }

  Widget _cycleInfo() {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (_, curr) => curr is CycleDetectedState,
      builder: (context, state) {
        final cycle = state is CycleDetectedState ? state.cycle : null;
        if (cycle == null) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink.shade100, Colors.purple.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade100.withAlpha(100),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.local_florist, color: Colors.pink, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chu kỳ liên quan")
                        .w600()
                        .text16()
                        .customColor(Colors.pink.shade700),
                    const SizedBox(height: 4),
                    Text(
                      "${cycle.cycleStartTime.globalDateFormat()} - ${cycle.cycleEndTime.globalDateFormat()}",
                    ).text14().w500().black87Color(),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _emoji() {
    final emojis = ['😊', '😢', '🤒', '🥰', '😡', '😴', '🌸', '🍫'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Cảm xúc"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (_, curr) => curr is EmojiUpdatedState,
          builder: (context, state) {
            String selectedEmoji =
            state is EmojiUpdatedState ? state.emoji : action.emoji ?? '';
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: emojis.map((emoji) {
                final isSelected = selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () =>
                      context.read<ActionBloc>().add(UpdateEmojiEvent(emoji)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Colors.pink.shade100
                          : AppColors.pinkBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.pink : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Text(emoji).text24(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _titleInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Tiêu đề"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (_, curr) => curr is TitleUpdatedState,
          builder: (context, state) {
            final text = state is TitleUpdatedState
                ? state.title
                : action.title ?? '';
            return TextField(
              controller: TextEditingController(text: text),
              onChanged: (t) =>
                  context.read<ActionBloc>().add(UpdateTitleEvent(t)),
              decoration: InputDecoration(
                hintText: "Nhập tiêu đề ngắn gọn...",
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.pink.shade100),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _noteInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Ghi chú"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (_, curr) => curr is NoteUpdatedState,
          builder: (context, state) {
            final text = state is NoteUpdatedState
                ? state.note
                : action.note ?? '';
            return TextField(
              controller: TextEditingController(text: text),
              maxLines: 3,
              onChanged: (t) =>
                  context.read<ActionBloc>().add(UpdateNoteEvent(t)),
              decoration: InputDecoration(
                hintText: "Nhập ghi chú nhẹ nhàng...",
                fillColor: Colors.white,
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.pink.shade100),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _actionType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Loại hành động"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (_, curr) => curr is ActionTypeUpdatedState,
          builder: (context, state) {
            ActionType? selectedType = state is ActionTypeUpdatedState
                ? state.type
                : action.type;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ActionType.values.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type.display),
                  selected: isSelected,
                  onSelected: (_) => context
                      .read<ActionBloc>()
                      .add(UpdateActionTypeEvent(isSelected ? null : type)),
                  checkmarkColor: Colors.pinkAccent,
                  selectedColor: Colors.pink.shade100,
                  backgroundColor: AppColors.pinkBackgroundColor,
                  labelStyle: TextStyle(
                    color:
                    isSelected ? Colors.pink.shade700 : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (_, curr) => curr is SaveButtonState,
      builder: (context, state) {
        final isEnabled = state is SaveButtonState ? state.isEnable : true;

        return SizedBox(
          width: double.infinity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isEnabled
                    ? [Colors.pink, Colors.orangeAccent]
                    : [Colors.pink.shade100, Colors.pink.shade100],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () => context
                  .read<ActionBloc>()
                  .add(UpdateActionDetailEvent())
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding:
                const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
              const Text("Cập nhật").text16().w600().whiteColor(),
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.pink.shade50,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.pink),
            Constants.hSpacer8,
            const Text("Xoá bản ghi?").text18().pinkColor(),
          ],
        ),
        content: const Text(
          "Bạn có chắc chắn muốn xoá hành động này không?",
        ).text16().w500().greyColor(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Huỷ").text16().pinkColor(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ActionBloc>()
                  .add(DeleteActionDetailEvent(action.id));
              context.pop();
            },
            child: const Text("Xoá").text16().w600().pinkColor(),
          ),
        ],
      ),
    );
  }

  Future<void> _showDialog(
      BuildContext context, String title, String content) async {
    await showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.pink.shade50,
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.pink),
            Constants.hSpacer8,
            Text(title).text18().pinkColor(),
          ],
        ),
        content: Text(content).text16().w500().greyColor(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              context.pop();
            },
            child: const Text("OK").text16().pinkColor(),
          ),
        ],
      ),
    );
  }
}
