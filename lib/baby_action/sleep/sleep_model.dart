
class SleepModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  int duration = 0;
  String note = '';
  DateTime stopTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  SleepModel({
    required this.id,
    required this.babyId,
    required this.note,
    required this.duration,
    required this.startTime,
    required this.stopTime,
    required this.createdTime,
    required this.updatedTime,
  });

  SleepModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    duration = 0;
    stopTime = DateTime.now();
    startTime = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  SleepModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    startTime = json['startTime'];
    note = json['note'];
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
    data['duration'] = duration;
    data['stopTime'] = stopTime.millisecondsSinceEpoch;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
