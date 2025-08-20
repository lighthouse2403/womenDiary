import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/schedule/bloc/schedule_bloc.dart';
import 'package:women_diary/schedule/bloc/schedule_event.dart';
import 'package:women_diary/schedule/bloc/schedule_state.dart';

class NewSchedule extends StatelessWidget {
  const NewSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleBloc(),
      child: const _CreateScheduleView(),
    );
  }
}

class _CreateScheduleView extends StatelessWidget {
  const _CreateScheduleView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScheduleBloc, ScheduleState>(
      listenWhen: (prev, curr) => curr is ScheduleSavedSuccessfullyState,
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
            content: const Text("Kế hoạch của bạn đã được lưu.").text16().w500().greyColor(),
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
        title: const Text("Tạo kế hoạch mới").text20().pinkColor().w600(),
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
            Constants.vSpacer24,
            _titleInput(context),
            Constants.vSpacer24,
            _noteInput(context),
            Constants.vSpacer24,
            _reminderSwitch(context),
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
        BlocBuilder<ScheduleBloc, ScheduleState>(
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

    context.read<ScheduleBloc>().add(UpdateTimeEvent(result));
  }

  Widget _titleInput(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Tiêu đề"),
        TextField(
          onChanged: (text) => context.read<ScheduleBloc>().add(UpdateTitleEvent(text)),
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
          maxLines: 3,
          onChanged: (text) => context.read<ScheduleBloc>().add(UpdateNoteEvent(text)),
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

  Widget _reminderSwitch(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _section("Nhắc nhở"),
        BlocBuilder<ScheduleBloc, ScheduleState>(
          buildWhen: (previous, current) => current is ReminderUpdatedState,
          builder: (context, state) {
            bool isReminderOn = state is ReminderUpdatedState ? state.isReminderOn : false;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Bật nhắc nhở").text16().w500(),
                Switch(
                  value: isReminderOn,
                  activeColor: Colors.pink,
                  onChanged: (value) {
                    context.read<ScheduleBloc>().add(UpdateReminderEvent(value));
                  },
                )
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return BlocBuilder<ScheduleBloc, ScheduleState>(
      buildWhen: (pre, current) => current is SaveButtonState,
      builder: (context, state) {
        final isEnabled = state is SaveButtonState ? state.isEnable : false;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled
                ? () { context.read<ScheduleBloc>().add(CreateScheduleDetailEvent()); }
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
}