import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/cycle/detail/action_time_line.dart';

class CycleDetail extends StatelessWidget {
  final CycleModel cycle;
  final dateFormat = DateFormat('dd/MM/yyyy');

  CycleDetail({super.key, required this.cycle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()
        ..add(LoadCycleDetailEvent(cycle)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaseAppBar(
          backgroundColor: Colors.pink[200],
          hasBack: true,
          title: 'Chi tiết',
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  onPressed: () {
                    context.read<CycleBloc>().add(UpdateCycleEvent());
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                );
              },
            ),
          ],
        ),
        body: BlocListener<CycleBloc, CycleState>(
          listener: (context, state) {
            if (state is CycleSavedSuccessfullyState) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: const Text('Thông báo'),
                    content: const Text('Đã lưu thành công!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
          child: BlocBuilder<CycleBloc, CycleState>(
            builder: (context, state) {
              final CycleModel currentCycle =
              state is LoadedCycleDetailState ? state.cycle : cycle;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _cycleInformation(currentCycle),
                  Constants.vSpacer20,
                  _timeLine(currentCycle),
                  Constants.vSpacer20,
                  _note(context, currentCycle),
                  Constants.vSpacer20,
                  BlocBuilder<CycleBloc, CycleState>(
                    buildWhen: (prev, curr) => curr is LoadedActionsState,
                    builder: (context, state) {
                      if (state is LoadedActionsState) {
                        return ActionTimeline(cycle: cycle, actions: state.actions);
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// --- Thông tin chu kỳ
  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label).w500()),
          Text(value).w600().customColor(Colors.pink.shade400),
        ],
      ),
    );
  }

  Widget _cycleInformation(CycleModel cycle) {
    DateTime cycleStartTime = cycle.cycleStartTime;
    DateTime cycleEndTime = cycle.cycleEndTime;
    DateTime menstruationEndTime = cycle.menstruationEndTime;

    final cycleDays = cycleEndTime.difference(cycleStartTime).inDays + 1;
    final menstruationDays = menstruationEndTime.difference(cycleStartTime).inDays + 1;
    final ovulationDate = cycleEndTime.subtract(const Duration(days: 14));

    return Column(
      children: [
        buildInfoRow('Bắt đầu', dateFormat.format(cycleStartTime)),
        buildInfoRow('Kết thúc', dateFormat.format(cycleEndTime)),
        const Divider(height: 24),
        buildInfoRow('Số ngày chu kỳ', '$cycleDays ngày'),
        buildInfoRow('Số ngày kinh nguyệt', '$menstruationDays ngày'),
        buildInfoRow('Ngày rụng trứng', dateFormat.format(ovulationDate)),
      ],
    );
  }

  /// --- Ghi chú
  Widget _note(BuildContext context, CycleModel cycle) {
    final controller = TextEditingController(text: cycle.note);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ghi chú', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nhập ghi chú...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 4,
          onChanged: (value) =>
              context.read<CycleBloc>().add(UpdateCycleNoteEvent(value)),
        ),
      ],
    );
  }

  /// --- Timeline chu kỳ
  Widget _timeLine(CycleModel cycle) {
    int cycleDays =
        cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    int menstruationDays =
        cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final ovulationDate =
    cycle.cycleEndTime.subtract(const Duration(days: 14));
    final ovulationIndex =
        ovulationDate.difference(cycle.cycleStartTime).inDays + 1;
    final follicularDays = ovulationIndex - menstruationDays;
    final lutealDays = cycleDays - ovulationIndex;
    double mensWidth = menstruationDays / cycleDays;
    double follicularWidth = follicularDays / cycleDays;
    double ovulationWidth = 1 / cycleDays;
    double lutealWidth = lutealDays / cycleDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Chi tiết').text16().w700(),
        const SizedBox(height: 12),
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          tween: Tween(begin: 0, end: 1),
          builder: (context, progress, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  _progressPhase(progress, mensWidth, Colors.pink.shade300,
                      '💗 $menstruationDays', true, false),
                  _progressPhase(progress - mensWidth, follicularWidth,
                      Colors.pink.shade100, '🌱 $follicularDays', false, false),
                  _progressPhase(progress - mensWidth - follicularWidth,
                      ovulationWidth, Colors.amber.shade300, '🌸', false, false),
                  _progressPhase(
                      progress -
                          mensWidth -
                          follicularWidth -
                          ovulationWidth,
                      lutealWidth,
                      Colors.purple.shade100,
                      '💜 $lutealDays',
                      false,
                      true),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _legendItem(Colors.pink.shade300, 'Kinh nguyệt 💗'),
            _legendItem(Colors.pink.shade100, 'Nang trứng 🌱'),
            _legendItem(Colors.amber.shade300, 'Rụng trứng 🌸'),
            _legendItem(Colors.purple.shade100, 'Hoàng thể 💜'),
          ],
        ),
      ],
    );
  }

  Widget _progressPhase(double progress, double width, Color color, String text,
      bool isFirst, bool isLast) {
    double visible =
    (progress <= 0) ? 0 : (progress < width ? progress : width);
    return Expanded(
      flex: (visible * 1000).round(),
      child: Container(
        alignment: Alignment.center,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.horizontal(
            left: isFirst ? const Radius.circular(16) : Radius.zero,
            right: isLast ? const Radius.circular(16) : Radius.zero,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Constants.hSpacer6,
        Text(text).text13(),
      ],
    );
  }
}
