
class EatingModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  int quantity = 0;
  String unit = '';
  String note = '';
  DateTime stopTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  EatingModel({
    required this.id,
    required this.babyId,
    required this.quantity,
    required this.note,
    required this.unit,
    required this.stopTime,
    required this.startTime,
    required this.createdTime,
    required this.updatedTime,
  });

  EatingModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    quantity = 0;
    note = '';
    unit = '';
    stopTime = DateTime.now();
    startTime = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  EatingModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    quantity = json['quantity'];
    note = json['note'];
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
    data['quantity'] = quantity;
    data['note'] = note;
    data['unit'] = unit;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['stopTime'] = stopTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
