import 'package:flutter/material.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/phase_model.dart';

class CycleInformation extends StatelessWidget {
  final int currentDay;
  final int cycleLength;
  final int remainDays;
  final PhaseModel phase;
  CycleInformation({
    required this.currentDay,
    required this.cycleLength,
    required this.remainDays,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(90),
        border: Border.all(color: Colors.white70, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Ngày $currentDay").black87Color().w700().text24(),
          Constants.vSpacer4,
          Text("Chu kỳ $cycleLength ngày").black87Color().text12(),
          Constants.vSpacer6,
          Text("Giai đoạn: ${phase.emoji}").text12().black87Color(),
          Constants.vSpacer4,
          Text("Còn lại $remainDays ngày").text12().customColor(Colors.orange),
        ],
      ),
    );
  }
}
