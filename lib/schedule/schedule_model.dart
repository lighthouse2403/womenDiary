
class ScheduleModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  DateTime time = DateTime.now();
  String title = '';
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  ScheduleModel({
    required this.id,
    required this.note,
    required this.time,
    required this.title,
    required this.createdTime,
    required this.updatedTime,
  });

  ScheduleModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    time = DateTime.now();
    title = '';
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  ScheduleModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    title = json['title'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['title'] = title;
    data['time'] = time.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
