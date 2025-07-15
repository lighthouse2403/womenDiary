
enum Gender {
  male('MALE'),
  female('FEMALE');

  final String label;
  const Gender(this.label);
}

extension GenderExtension on Gender {
  static Gender? fromLabel(String value) {
    return Gender.values.firstWhere(
          (e) => e.label == value,
      orElse: () => Gender.male, // hoặc trả về null nếu muốn
    );
  }
}

class BabyModel {
  String babyId = '${DateTime.now().microsecondsSinceEpoch}';
  String babyName = '';
  Gender gender = Gender.male;
  DateTime birthDate = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();
  int selected = 0;

  BabyModel({
    required this.babyId,
    required this.babyName,
    required this.gender,
    required this.birthDate,
    required this.createdTime,
    required this.updatedTime,
  });

  BabyModel.init() {
    babyId = '${DateTime.now().microsecondsSinceEpoch}';
    babyName = '';
    gender = Gender.male;
    birthDate = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
    selected = 0;
  }

  BabyModel.fromDatabase(Map<String, dynamic> json) {
    babyId = json['babyId'];
    babyName = json['babyName'];
    gender = GenderExtension.fromLabel(json['gender']) ?? Gender.male;
    birthDate = DateTime.fromMicrosecondsSinceEpoch(json['birthDate'] as int);
    createdTime = DateTime.fromMicrosecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMicrosecondsSinceEpoch(json['updatedTime'] as int);
    if (json['selected'] != null) {
      selected = json['selected'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['babyId'] = babyId;
    data['babyName'] = babyName;
    data['gender'] = gender.label;
    data['birthDate'] = birthDate.microsecondsSinceEpoch;
    data['createdTime'] = createdTime.microsecondsSinceEpoch;
    data['updatedTime'] = updatedTime.microsecondsSinceEpoch;
    data['selected'] = selected;

    return data;
  }
}