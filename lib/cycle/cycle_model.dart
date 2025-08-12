
class CycleModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String note = '';
  DateTime cycleStartTime = DateTime.now();
  DateTime cycleEndTime = DateTime.now();
  DateTime menstruationEndTime = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  CycleModel(
    this.cycleStartTime,
  );

  CycleModel.init(DateTime cycleStartTime, DateTime cycleEndTime) {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    note = '';
    this.cycleStartTime = cycleStartTime;
    this.cycleEndTime = cycleEndTime;
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  CycleModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    note = json['note'];
    cycleStartTime = DateTime.fromMillisecondsSinceEpoch(json['cycleStartTime'] as int);
    cycleEndTime = DateTime.fromMillisecondsSinceEpoch(json['cycleEndTime'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['note'] = note;
    data['id'] = id;
    data['cycleStartTime'] = cycleStartTime.millisecondsSinceEpoch;
    data['cycleEndTime'] = cycleEndTime.millisecondsSinceEpoch;
    data['menstruationEndTime'] = menstruationEndTime.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
