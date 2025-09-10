import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/home/phase_model.dart';

class ActionTimeline extends StatelessWidget {
  final CycleModel cycle;
  final List<ActionModel> actions;

  const ActionTimeline({super.key, required this.cycle, required this.actions});

  @override
  Widget build(BuildContext context) {
    final sortedActions = [...actions]..sort((a, b) => b.time.compareTo(a.time));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sortedActions.length,
      itemBuilder: (context, index) {
        final action = sortedActions[index];
        final dayOfCycle = action.time.difference(cycle.cycleStartTime).inDays + 1;
        final cycleLength = cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
        final menstruationLength = cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;

        List<PhaseModel> phases = _buildPhases(cycleLength, menstruationLength);
        PhaseModel currentPhase = _findCurrentPhase(phases, dayOfCycle, cycleLength);
        final color = currentPhase.color;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // timeline line + dot
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
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(action.emoji ?? "🌸", style: const TextStyle(fontSize: 10)),
                ),
                Container(
                  width: 2,
                  height: 60,
                  color: index == sortedActions.length - 1
                      ? Colors.transparent
                      : Colors.grey.shade300,
                ),
              ],
            ),
            const SizedBox(width: 12),

            // bubble content
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border(left: BorderSide(color: color, width: 3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Phase badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${currentPhase.emoji} • Ngày $dayOfCycle",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color.withAlpha(60),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Title
                    Text(
                      action.title ?? "Không có tiêu đề",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: color.withAlpha(75),
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
          ],
        );
      },
    );
  }

  List<PhaseModel> _buildPhases(int cycleLength, int menstruationLength) {
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
