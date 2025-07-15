
class ScheduleModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  DateTime time = DateTime.now();
  String url = '';
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  ScheduleModel({
    required this.id,
    required this.babyId,
    required this.note,
    required this.time,
    required this.url,
    required this.createdTime,
    required this.updatedTime,
  });

  ScheduleModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    time = DateTime.now();
    url = '';
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  ScheduleModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    note = json['note'];
    url = json['url'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['babyId'] = babyId;
    data['note'] = note;
    data['url'] = url;
    data['time'] = time.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
