
class PeriodModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  DateTime stopTime = DateTime.now();
  DateTime startTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  PeriodModel({
    required this.id,
    required this.note,
    required this.stopTime,
    required this.startTime,
    required this.createdTime,
    required this.updatedTime,
  });

  PeriodModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    stopTime = DateTime.now();
    startTime = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  PeriodModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    stopTime = DateTime.fromMillisecondsSinceEpoch(json['stopTime'] as int);
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['stopTime'] = stopTime.millisecondsSinceEpoch;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
