
class TemperatureModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  String temperature = '37.0';
  String note = '';
  String url = '';
  DateTime time = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  TemperatureModel({
    required this.id,
    required this.babyId,
    required this.temperature,
    required this.note,
    required this.url,
    required this.time,
    required this.createdTime,
    required this.updatedTime,
  });

  TemperatureModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    temperature = '37.0';
    note = '';
    url = '';
    time = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  TemperatureModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    temperature = json['temperature'];
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
    data['temperature'] = temperature;
    data['note'] = note;
    data['url'] = url;
    data['time'] = time.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    data['date'] = (time.millisecondsSinceEpoch/(86400*1000)).round();

    return data;
  }
}