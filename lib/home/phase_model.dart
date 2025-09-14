import 'package:flutter/material.dart';

enum PhaseType { menstruation, follicular, ovulation, luteal }

extension PhaseTypeExtension on PhaseType {
  String get emoji {
    switch (this) {
      case PhaseType.menstruation:
        return "🩸";
      case PhaseType.follicular:
        return "🍃";
      case PhaseType.ovulation:
        return "🌸";
      case PhaseType.luteal:
        return "🌙";
    }
  }

  Color get color {
    switch (this) {
      case PhaseType.menstruation:
        return Colors.pink.shade400;
      case PhaseType.follicular:
        return Colors.teal.shade200;
      case PhaseType.ovulation:
        return Colors.amber.shade400;
      case PhaseType.luteal:
        return Colors.purple.shade200;
    }
  }

  String get label {
    switch (this) {
      case PhaseType.menstruation:
        return "Kinh nguyệt";
      case PhaseType.follicular:
        return "Nang noãn";
      case PhaseType.ovulation:
        return "Rụng trứng";
      case PhaseType.luteal:
        return "Hoàng thể";
    }
  }
}

class PhaseModel {
  final PhaseType type;
  final String emoji;
  final int days;
  final Color color;
  final int startDay;

  PhaseModel({
    required this.type,
    required this.days,
    required this.startDay,
  })  : emoji = type.emoji,
        color = type.color;
}

class PhaseFactory {
  static List<PhaseModel> createPhases({
    required int cycleLength,
    required int menstruationLength,
  }) {
    // Tính ngày rụng trứng
    final ovulationDay = cycleLength - 14;

    // Cửa sổ màu mỡ
    final fertileStart = ovulationDay - 5;
    final fertileEnd = ovulationDay + 1;
    final afterFertileStart = fertileEnd + 1;

    return [
      PhaseModel(
        type: PhaseType.menstruation,
        days: menstruationLength,
        startDay: 1,
      ),
      PhaseModel(
        type: PhaseType.follicular,
        days: fertileStart - (menstruationLength + 1),
        startDay: menstruationLength + 1,
      ),
      PhaseModel(
        type: PhaseType.ovulation,
        days: fertileEnd - fertileStart + 1,
        startDay: fertileStart,
      ),
      PhaseModel(
        type: PhaseType.luteal,
        days: cycleLength - fertileEnd,
        startDay: afterFertileStart,
      ),
    ];
  }
}
