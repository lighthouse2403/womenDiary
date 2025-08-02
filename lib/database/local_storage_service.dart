
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  String cycleLengthKey = 'cycleLength';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ----------------------------- FIXED VALUES -------------------------------
  static Future<void> updateUuid(String uuid) async {
    await _prefs?.setString('uuid', uuid);
  }

  static String getUuid() {
    return _prefs?.getString('uuid') ?? '';
  }

  /// ----------------------------- FIXED VALUES -------------------------------
  static Future<void> updateCycleLength(int cycleLength) async {
    await _prefs?.setInt('cycleLength', cycleLength);
  }

  static Future<int> getCycleLength() async {
    return await _prefs?.getInt('cycleLength') ?? 0;
  }

  /// Menstrual length
  static Future<void> updateMenstruationLength(int menstrualLength) async {
    await _prefs?.setInt('updateMenstruationLength', menstrualLength);
  }

  static Future<int> getMenstruationLength() async {
    return await _prefs?.getInt('updateMenstruationLength') ?? 0;
  }

  /// Goal
  static Future<void> updateGoal(UserGoal goal) async {
    await _prefs?.setInt('goal', goal.value);
  }

  static UserGoal getGoal() {
    int goalValue = _prefs?.getInt('goal') ?? 0;
    return UserGoal.fromInt(goalValue);
  }

  /// Biometric
  static Future<void> updateUsingBiometric(bool useBiometric) async {
    await _prefs?.setBool('use_biometric', useBiometric);
  }

  static bool checkUsingBiometric() {
    return _prefs?.getBool('use_biometric') ?? false;
  }

  /// ----------------------------- AVERAGE VALUES -----------------------------

  static Future<void> updateUsingAverageValue(bool isUsingAverageValue) async {
    await _prefs?.setBool('isUsingAverageValue', isUsingAverageValue);
  }

  static bool isUsingAverageValue() {
    return _prefs?.getBool('isUsingAverageValue') ?? false;
  }

  /// Average Mestruation length
  static Future<void> updateAverageMenstruationLength(int cycleLength) async {
    await _prefs?.setInt('averageMenstruationLength', cycleLength);
  }

  static int getAverageMenstruationLength() {
    return _prefs?.getInt('averageMenstruationLength') ?? 7;
  }

  /// Average Cycle length
  static Future<void> updateAverageCycleLength(int cycleLength) async {
    await _prefs?.setInt('averageCycleLength', cycleLength);
  }

  static int getAverageCycleLength() {
    return _prefs?.getInt('averageCycleLength') ?? 30;
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
