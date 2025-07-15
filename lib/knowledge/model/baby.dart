import 'package:hive/hive.dart';
part 'baby.g.dart';

@HiveType(typeId: 1, adapterName: 'BabyAdapter')
class Baby {
  @HiveField(0)
  String? motherName;

  @HiveField(1)
  String? babyName;

  @HiveField(2)
  double? weight;

  @HiveField(3)
  DateTime? birthday;

  @HiveField(4)
  int? days;

  @HiveField(5)
  DateTime? lastPeriod;

  Baby();

  Baby copyWith({
    String? motherName,
    String? babyName,
    double? weight,
    DateTime? birthday,
    int? days,
    DateTime? lastPeriod
  }) {
    return Baby()
      ..motherName = motherName ?? this.motherName
      ..babyName = babyName ?? this.babyName
      ..weight = weight ?? this.weight
      ..birthday = birthday ?? this.birthday
      ..days = days ?? this.days
      ..lastPeriod = lastPeriod ?? this.lastPeriod;
  }
}