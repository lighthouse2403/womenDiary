
class BottleMilkModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  String url = '';
  int quantity = 0;
  DateTime stopTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  BottleMilkModel({
    required this.id,
    required this.babyId,
    required this.note,
    required this.url,
    required this.quantity,
    required this.stopTime,
    required this.startTime,
    required this.createdTime,
    required this.updatedTime,
  });

  BottleMilkModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    quantity = 0;
    note = '';
    url = '';
    stopTime = DateTime.now();
    startTime = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  BottleMilkModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    quantity = json['quantity'];
    note = json['note'];
    url = json['url'];
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int);
    stopTime = DateTime.fromMillisecondsSinceEpoch(json['stopTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['babyId'] = babyId;
    data['quantity'] = quantity;
    data['note'] = note;
    data['url'] = url;
    data['stopTime'] = stopTime.millisecondsSinceEpoch;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;

    return data;
  }
}
