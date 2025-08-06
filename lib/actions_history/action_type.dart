enum ActionType {
  medicine,
  stomachache,
  tired,
  sweetCraving,
  hotInside,
}

extension ActionTypeExtension on ActionType {
  String get emoji {
    switch (this) {
      case ActionType.medicine:
        return '💊';
      case ActionType.stomachache:
        return '🤕';
      case ActionType.tired:
        return '😴';
      case ActionType.sweetCraving:
        return '🍫';
      case ActionType.hotInside:
        return '🥵';
    }
  }

  String get label {
    switch (this) {
      case ActionType.medicine:
        return 'Uống thuốc';
      case ActionType.stomachache:
        return 'Đau bụng';
      case ActionType.tired:
        return 'Mệt mỏi';
      case ActionType.sweetCraving:
        return 'Thèm đồ ngọt';
      case ActionType.hotInside:
        return 'Nóng trong';
    }
  }

  String get display => '$emoji $label';

  int toInt() => index; // lưu dưới dạng int
}

// Factory từ int → enum
extension ActionTypeFromInt on int {
  ActionType toActionType() {
    if (this >= 0 && this < ActionType.values.length) {
      return ActionType.values[this];
    } else {
      throw ArgumentError('Invalid int value for ActionType: $this');
    }
  }
}