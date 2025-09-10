import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

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
                  const SizedBox(height: 20),
                  _timeLine(currentCycle),
                  const Divider(height: 30),
                  _note(context, currentCycle),
                  const SizedBox(height: 20),
                  BlocBuilder<CycleBloc, CycleState>(
                    buildWhen: (prev, curr) => curr is LoadedActionsState,
                    builder: (context, state) {
                      if (state is LoadedActionsState) {
                        return _actionTimeline(currentCycle, state.actions);
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
    final cycleDays =
        cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final menstruationDays =
        cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final ovulationDate =
    cycle.cycleEndTime.subtract(const Duration(days: 14));

    return Column(
      children: [
        buildInfoRow('Bắt đầu', dateFormat.format(cycle.cycleStartTime)),
        buildInfoRow('Kết thúc', dateFormat.format(cycle.cycleEndTime)),
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
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  /// --- Danh sách hành động
  /// --- Danh sách hành động (dạng timeline)
  Widget _actionTimeline(CycleModel cycle, List<ActionModel> actions) {
    if (actions.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Hành động").text16().w700(),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text("Chưa có hành động nào trong chu kỳ này")
                .text14()
                .greyColor(),
          ),
        ],
      );
    }

    // sort từ mới -> cũ
    final sorted = [...actions]..sort((a, b) => b.time.compareTo(a.time));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hành động").text16().w700(),
        const SizedBox(height: 8),
        ListView.builder(
          itemCount: sorted.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _timelineItem(
              context,
              cycle,
              sorted[index],
              index,
              index == sorted.length - 1,
            );
          },
        ),
      ],
    );
  }

  Widget _timelineItem(
      BuildContext context,
      CycleModel cycle,
      ActionModel action,
      int index,
      bool isLast
      ) {
    final dayOfCycle = action.time.difference(cycle.cycleStartTime).inDays + 1;
    final cycleLength =
        cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final menstruationLength =
        cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;

    final phases = _buildPhases(cycleLength, menstruationLength);
    final currentPhase = _findCurrentPhase(phases, dayOfCycle, cycleLength);
    final phaseColor = currentPhase.color;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 2,
              height: 20,
              color: index == 0 ? Colors.transparent : Colors.grey.shade300,
            ),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: phaseColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                action.emoji ?? "🌸",
                style: const TextStyle(fontSize: 10),
              ),
            ),
            Container(
              width: 2,
              height: isLast ? 20 : 60,
              color: isLast ? Colors.transparent : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),

        // --- bubble content ---
        Expanded(
          child: GestureDetector(
            onTap: () => context.navigateTo(RoutesName.actionDetail, arguments: action),
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: phaseColor.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
                border: Border(left: BorderSide(color: phaseColor, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Phase + Ngày
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: phaseColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${currentPhase.emoji} Ngày $dayOfCycle",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: phaseColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  Text(
                    action.title ?? "Không có tiêu đề",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: phaseColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat("dd/MM/yyyy HH:mm").format(action.time),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),

                  if (action.note.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(action.note, style: const TextStyle(fontSize: 14)),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<PhaseModel> _buildPhases(
      int cycleLength, int menstruationLength) {
    final int ovulationDay = cycleLength - 14;
    final int fertileStart = ovulationDay - 5;
    final int fertileEnd = ovulationDay + 1;
    final int afterFertileStart = fertileEnd + 1;

    return [
      PhaseModel("🩸", menstruationLength, Colors.pink.shade400, 1),
      PhaseModel("🍃", fertileStart - (menstruationLength + 1),
          Colors.teal.shade200, menstruationLength + 1),
      PhaseModel("🌸", fertileEnd - fertileStart + 1, Colors.amber.shade400,
          fertileStart),
      PhaseModel(
          "🌙", cycleLength - fertileEnd, Colors.purple.shade200, afterFertileStart),
    ];
  }

  PhaseModel _findCurrentPhase(List<PhaseModel> phases, int currentDay, int cycleLength) {
    for (final phase in phases) {
      final start = phase.startDay;
      final end = start + phase.days - 1;
      if (currentDay >= start && currentDay <= end) {
        return phase;
      }
    }

    // Nếu currentDay vượt quá (cuối chu kỳ) thì wrap về phase đầu tiên
    return phases.last;
  }
}
