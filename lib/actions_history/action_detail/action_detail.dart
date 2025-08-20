import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ActionDetail extends StatelessWidget {
  const ActionDetail({super.key, required this.action});

  final ActionModel action;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionBloc()..add(InitActionDetailEvent(action)),
      child: _ActionDetailView(action: action,),
    );
  }
}

class _ActionDetailView extends StatefulWidget {
  const _ActionDetailView({required this.action});
  final ActionModel action;

  @override
  State<_ActionDetailView> createState() => _ActionDetailViewState();
}

class _ActionDetailViewState extends State<_ActionDetailView> {
  late final TextEditingController titleController;
  late final TextEditingController noteController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.action.title ?? '');
    noteController = TextEditingController(text: widget.action.note ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionBloc, ActionState>(
      listenWhen: (prev, curr) => curr is ActionSavedSuccessfullyState,
      listener: (context, state) async {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            backgroundColor: Colors.pink.shade50,
            title: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.pink),
                Constants.hSpacer8,
                const Text("Thành công!").text18().pinkColor(),
              ],
            ),
            content: const Text("Hành động của bạn đã được lưu.").text16().w500().greyColor(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                child: const Text("OK").text16().pinkColor(),
              ),
            ],
          ),
        );
      },
      child: _mainScaffold(context),
    );
  }

  Widget _mainScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Chi tiết hành động").text20().pinkColor().w600(),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.pink),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timePicker(),
            Constants.vSpacer24,
            _emoji(),
            Constants.vSpacer24,
            _actionType(),
            Constants.vSpacer24,
            _titleInput(context),
            Constants.vSpacer24,
            _noteInput(context),
            Constants.vSpacer40,
            _saveButton(context),
          ],
        ),
      ),
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
          buildWhen: (previous, current) => current is TimeUpdatedState,
          builder: (context, state) {
            DateTime time = state is TimeUpdatedState ? state.time : DateTime.now();
            return InkWell(
              onTap: () => _pickDateTime(context, time),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.pinkBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.pink.shade100),
                ),
                child: Text(DateFormat('dd/MM/yyyy – HH:mm').format(time)).text16().w500(),
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

    context.read<ActionBloc>().add(UpdateTimeEvent(result));
  }

  Widget _emoji() {
    final emojis = ['😊', '😢', '🤒', '🥰', '😡', '😴', '🌸', '🍫'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Cảm xúc"),
        BlocBuilder<ActionBloc, ActionState>(
          buildWhen: (pre, current) => current is EmojiUpdatedState,
          builder: (context, state) {
            String selectedEmoji = state is EmojiUpdatedState ? state.emoji : '';
            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: emojis.map((emoji) {
                final isSelected = selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => context.read<ActionBloc>().add(UpdateEmojiEvent(emoji)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink.shade100 : AppColors.pinkBackgroundColor,
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
        TextField(
          controller: titleController,
          onChanged: (text) => context.read<ActionBloc>().add(UpdateTitleEvent(text)),
          decoration: InputDecoration(
            hintText: "Nhập tiêu đề ngắn gọn...",
            fillColor: AppColors.pinkBackgroundColor,
            filled: true,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _noteInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Ghi chú"),
        TextField(
          controller: noteController,
          maxLines: 3,
          onChanged: (text) => context.read<ActionBloc>().add(UpdateNoteEvent(text)),
          decoration: InputDecoration(
            hintText: "Nhập ghi chú nhẹ nhàng...",
            fillColor: AppColors.pinkBackgroundColor,
            filled: true,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
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
          buildWhen: (pre, current) => current is ActionTypeUpdatedState,
          builder: (context, state) {
            ActionType? selectedType = state is ActionTypeUpdatedState
                ? state.type
                : ActionType.stomachache;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ActionType.values.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type.display),
                  selected: isSelected,
                  onSelected: (_) => context.read<ActionBloc>().add(
                      UpdateActionTypeEvent(isSelected ? null : type)),
                  checkmarkColor: Colors.pinkAccent,
                  selectedColor: Colors.pink.shade100,
                  backgroundColor: AppColors.pinkBackgroundColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.pink.shade700 : Colors.black87,
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
      buildWhen: (pre, current) => current is SaveButtonState,
      builder: (context, state) {
        final isEnabled = state is SaveButtonState ? state.isEnable : false;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () { context.read<ActionBloc>().add(CreateActionDetailEvent()); }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEnabled ? Colors.pink : Colors.pink.shade100,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Lưu lại").text16().w600().whiteColor(),
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
        content: const Text("Bạn có chắc chắn muốn xoá hành động này không?")
            .text16().w500().greyColor(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Huỷ").text16().pinkColor(),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<ActionBloc>().add(DeleteActionDetailEvent(widget.action.id));
              Navigator.of(context).pop(); // thoát khỏi màn detail
            },
            child: const Text("Xoá").text16().w600().pinkColor(),
          ),
        ],
      ),
    );
  }

}