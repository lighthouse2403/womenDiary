
class OtherModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  int quantity = 0;
  int duration = 0;
  String url = '';
  String note = '';
  DateTime time = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  OtherModel({
    required this.id,
    required this.babyId,
    required this.quantity,
    required this.duration,
    required this.note,
    required this.url,
    required this.time,
    required this.createdTime,
    required this.updatedTime,
  });

  OtherModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    quantity = 0;
    duration = 0;
    note = '';
    url = '';
    time = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  OtherModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    quantity = json['leftQuantity'];
    note = json['note'];
    duration = json['duration'];
    url = json['url'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['babyId'] = babyId;
    data['quantity'] = quantity;
    data['duration'] = duration;
    data['note'] = note;
    data['url'] = url;
    data['time'] = time.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    data['date'] = (updatedTime.millisecondsSinceEpoch/(86400*1000)).round();
    return data;
  }
}