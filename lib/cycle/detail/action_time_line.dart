import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class ActionTimeline extends StatelessWidget {
  final CycleModel cycle;
  final List<ActionModel> actions;

  const ActionTimeline({super.key, required this.cycle, required this.actions});

  @override
  Widget build(BuildContext context) {

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

    final phases = PhaseFactory.createPhases(
        cycleLength: cycleLength,
        menstruationLength: menstruationLength
    );
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
              child: Text(action.emoji).text10(),
            ),
            Container(
              width: 2,
              height: isLast ? 20 : 60,
              color: isLast ? Colors.transparent : Colors.grey.shade300,
            ),
          ],
        ),
        Constants.hSpacer10,

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
                    color: phaseColor.withAlpha(40),
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
                      color: phaseColor.withAlpha(40),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("${currentPhase.emoji} Ngày $dayOfCycle")
                        .w600()
                        .text12()
                        .customColor(phaseColor),
                  ),
                  Constants.vSpacer8,
                  Text(action.title).w600().text16().customColor(phaseColor),
                  Constants.vSpacer8,
                  Text(
                    DateFormat("dd/MM/yyyy HH:mm").format(action.time),
                  ).greyColor().text13(),

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
