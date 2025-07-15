
enum ActionType {
  bath,
  bottleMilk,
  motherMilk,
  eating,
  peePoo,
  pee,
  poo,
  sleep,
  temperature,
  vaccination,
}

extension ActionTypeExtension on ActionType {
  int get value {
    switch (this) {
      case ActionType.bath:
        return 0;
      case ActionType.bottleMilk:
        return 1;
      case ActionType.motherMilk:
        return 2;
      case ActionType.eating:
        return 3;
      case ActionType.peePoo:
        return 4;
      case ActionType.pee:
        return 5;
      case ActionType.poo:
        return 6;
      case ActionType.sleep:
        return 7;
      case ActionType.temperature:
        return 8;
      case ActionType.vaccination:
        return 9;
    }
  }

  String get label {
    switch (this) {
      case ActionType.bath:
        return 'Tắm';
      case ActionType.bottleMilk:
        return 'Sữa bình';
      case ActionType.motherMilk:
        return 'Sữa mẹ';
      case ActionType.eating:
        return 'Ăn';
      case ActionType.peePoo:
        return 'ị+tè';
      case ActionType.pee:
        return 'Tè';
      case ActionType.poo:
        return 'Ị';
      case ActionType.sleep:
        return 'Ngủ';
      case ActionType.temperature:
        return 'Đo nhiệt độ';
      case ActionType.vaccination:
        return 'Tiêm chủng';
    }
  }

  static ActionType fromInt(int value) {
    switch (value) {
      case 0:
        return ActionType.bath;
      case 1:
        return ActionType.bottleMilk;
      case 2:
        return ActionType.motherMilk;
      case 3:
        return ActionType.eating;
      case 4:
        return ActionType.peePoo;
      case 5:
        return ActionType.pee;
      case 6:
        return ActionType.poo;
      case 7:
        return ActionType.sleep;
      case 8:
        return ActionType.temperature;
      case 9:
        return ActionType.vaccination;
      default:
        throw Exception('Invalid role value');
    }
  }
}

class BabyActionModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  ActionType type = ActionType.bath;
  String note = '';
  DateTime stopTime = DateTime.now();
  DateTime startTime = DateTime.now();
  String url = '';
  String value = '';
  String unit = '';
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  BabyActionModel({
    required this.id,
    required this.babyId,
    required this.type,
    required this.note,
    required this.stopTime,
    required this.startTime,
    required this.value,
    required this.url,
    required this.unit,
    required this.createdTime,
    required this.updatedTime,
  });

  BabyActionModel.init(ActionType actionType) {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    type = actionType;
    note = '';
    stopTime = DateTime.now();
    startTime = DateTime.now();
    url = '';
    value = '';
    unit = '';
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  BabyActionModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    note = json['note'];
    type = ActionTypeExtension.fromInt(json['type']);
    url = json['url'];
    value = json['value'];
    unit = json['unit'];
    stopTime = DateTime.fromMillisecondsSinceEpoch(json['stopTime'] as int);
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['babyId'] = babyId;
    data['note'] = note;
    data['type'] = type.value;
    data['url'] = url;
    data['value'] = value;
    data['unit'] = unit;
    data['stopTime'] = stopTime.millisecondsSinceEpoch;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
