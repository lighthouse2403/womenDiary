
class MenstruationModel {
  String note = '';
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  MenstruationModel({
    required this.endTime,
    required this.startTime,
  });

  MenstruationModel.init(DateTime startTime, DateTime endTime) {
    note = '';
    this.startTime = startTime;
    this.endTime = endTime;
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  MenstruationModel.fromDatabase(Map<String, dynamic> json) {
    note = json['note'];
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int);
    endTime = DateTime.fromMillisecondsSinceEpoch(json['endTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['endTime'] = endTime.millisecondsSinceEpoch;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
