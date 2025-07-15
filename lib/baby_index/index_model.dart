
enum IndexType {
  height,
  weight
}

extension IndexTypeExtension on IndexType {
  int get value {
    switch (this) {
      case IndexType.height:
        return 0;
      case IndexType.weight:
        return 1;
    }
  }

  static IndexType fromInt(int value) {
    switch (value) {
      case 0:
        return IndexType.height;
      case 1:
        return IndexType.weight;
      default:
        throw Exception('Invalid role value');
    }
  }
}

class IndexModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String babyId = '${DateTime.now().millisecondsSinceEpoch}';
  IndexType type = IndexType.height;
  String note = '';
  String value = '';
  DateTime time = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();


  IndexModel({
    required this.id,
    required this.babyId,
    required this.type,
    required this.note,
    required this.value,
    required this.time,
    required this.createdTime,
    required this.updatedTime,
  });

  IndexModel.init(IndexType indexType) {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    babyId = '${DateTime.now().millisecondsSinceEpoch}';
    type = indexType;
    note = '';
    time = DateTime.now();
    value = '';
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  IndexModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    babyId = json['babyId'];
    note = json['note'];
    type = IndexTypeExtension.fromInt(json['type']);
    value = json['value'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['babyId'] = babyId;
    data['note'] = note;
    data['type'] = type.value;
    data['value'] = value;
    data['time'] = time.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;
    return data;
  }
}
