
class MenstruationModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  int length = 1;
  DateTime startTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  MenstruationModel({
    required this.id,
    required this.note,
    required this.length,
    required this.startTime,
    required this.createdTime,
    required this.updatedTime,
  });

  MenstruationModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    length = 1;
    startTime = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  MenstruationModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    length = json['length'];
    startTime = DateTime.fromMillisecondsSinceEpoch(json['startTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note'] = note;
    data['length'] = length;
    data['startTime'] = startTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
