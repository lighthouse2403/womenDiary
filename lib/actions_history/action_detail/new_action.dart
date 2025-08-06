import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class NewAction extends StatelessWidget {
  const NewAction({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserActionBloc(),
      child: const _CreateActionView(),
    );
  }
}

class _CreateActionView extends StatelessWidget {
  const _CreateActionView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserActionBloc, UserActionState>(
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
                const SizedBox(width: 8),
                const Text("Thành công!").text18().pinkColor(),
              ],
            ),
            content: const Text("Hành động của bạn đã được lưu.")
                .text16()
                .w500()
                .greyColor(),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back screen
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
        title: const Text("Tạo hành động mới").pinkColor(),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pink),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _timePicker(),
            Constants.vSpacer20,
            _emoji(),
            Constants.vSpacer20,
            _actionType(),
            Constants.vSpacer20,
            _noteInput(context),
            Constants.vSpacer30,
            _saveButton(context),
          ],
        ),
      ),
    );
  }

  Widget _section(String title) => Text(title).text18().w600().pinkColor();

  Widget _timePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Thời gian"),
        BlocBuilder<UserActionBloc, UserActionState>(
          buildWhen: (previous, current) => current is TimeUpdatedState,
          builder: (context, state) {
            DateTime time = state is TimeUpdatedState ? state.time : DateTime.now();
            return InkWell(
              onTap: () => _pickDateTime(context, time),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.pinkBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(DateFormat('dd/MM/yyyy – HH:mm').format(time)).text16(),
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

    context.read<UserActionBloc>().add(UpdateTimeEvent(result));
  }

  Widget _emoji() {
    final emojis = ['😊', '😢', '🤒', '🥰', '😡', '😴', '🌸', '🍫'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Cảm xúc"),
        BlocBuilder<UserActionBloc, UserActionState>(
          buildWhen: (pre, current) => current is EmojiUpdatedState,
          builder: (context, state) {
            String selectedEmoji = state is EmojiUpdatedState ? state.emoji : '';
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: emojis.map((emoji) {
                final isSelected = selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => context.read<UserActionBloc>().add(UpdateEmojiEvent(emoji)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink.shade100 : AppColors.pinkBackgroundColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.pink : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Text(emoji).text30(),
                  ),
                );
              }).toList(),
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
        Constants.vSpacer8,
        TextField(
          maxLines: 3,
          onChanged: (text) => context.read<UserActionBloc>().add(UpdateNoteEvent(text)),
          decoration: InputDecoration(
            hintText: "Nhập ghi chú nhẹ nhàng...",
            fillColor: AppColors.pinkBackgroundColor,
            filled: true,
            contentPadding: const EdgeInsets.all(14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
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
        Constants.vSpacer10,
        BlocBuilder<UserActionBloc, UserActionState>(
          buildWhen: (pre, current) => current is ActionTypeUpdatedState,
          builder: (context, state) {
            ActionType? selectedType = state is ActionTypeUpdatedState
                ? state.type
                : ActionType.stomachache;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ActionType.values.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type.display),
                  selected: isSelected,
                  onSelected: (_) => context.read<UserActionBloc>().add(
                      UpdateActionTypeEvent(isSelected ? null : type)),
                  selectedColor: Colors.pink.shade100,
                  backgroundColor: AppColors.pinkBackgroundColor,
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          context.read<UserActionBloc>().add(CreateActionDetailEvent());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: const Text("Lưu").text16().whiteColor(),
      ),
    );
  }
}
