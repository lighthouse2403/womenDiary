import 'package:women_diary/database/data_handler.dart';

class ActionModel {
   String id = '${DateTime.now().millisecondsSinceEpoch}';
   String emoji = '';
   String title = '';
   String note = '';
   String cycleId = '';
   String typeId = '';
   DateTime time = DateTime.now();

  ActionModel({
    required this.id,
    required this.emoji,
    required this.time
  });

  ActionModel.init(String title, DateTime time, String emoji, String note) {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    emoji  = emoji;
    title  = title;
    note   = note;
    time   = time;
    typeId = '';
  }

  ActionModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    emoji = json['emoji'];
    title = json['title'];
    note = json['note'];
    cycleId = json['cycleId'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    typeId = json['typeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emoji'] = emoji;
    data['title'] = title;
    data['note'] = note;
    data['time'] = time.millisecondsSinceEpoch;
    data['typeId'] = typeId;
    data['cycleId'] = cycleId;
    return data;
  }
}

class ActionTypeModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String emoji = '';
  String title = '';
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  ActionTypeModel({
    required this.id,
    required this.title,
    required this.emoji,
  });

  ActionTypeModel.init(String title, String emoji) {
    this.id = '${DateTime.now().millisecondsSinceEpoch}';
    this.emoji  = emoji;
    this.title  = title;
  }

  ActionTypeModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    emoji = json['emoji'];
    title = json['title'];
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emoji'] = emoji;
    data['title'] = title;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}