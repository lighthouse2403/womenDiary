
import 'package:shared_preferences/shared_preferences.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  String cycleLengthKey = 'cycleLength';
  static String _skipVersionKey = "skip_version";
  static String _averageCycle = 'averageCycleLength';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ----------------------------- LOCAL VALUES -------------------------------
  static Future<void> updateLanguage(String languageId) async {
    await _prefs?.setString('languageId', languageId);
  }

  static Future<String> getLanguage() async {
    return await _prefs?.getString('languageId') ?? 'vi';
  }

  /// ----------------------------- UUID VALUES -------------------------------
  static Future<void> updateUuid(String uuid) async {
    await _prefs?.setString('uuid', uuid);
  }

  static Future<String> getUuid() async {
    return await _prefs?.getString('uuid') ?? '';
  }

  /// ----------------------------- CYCLE VALUES -------------------------------
  static Future<void> updateCycleLength(int cycleLength) async {
    await _prefs?.setInt('cycleLength', cycleLength);
  }

  static Future<int> getCycleLength() async {
    return _prefs?.getInt('cycleLength') ?? 0;
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

  static Future<UserGoal> getGoal() async {
    int goalValue = _prefs?.getInt('goal') ?? 0;
    return UserGoal.fromInt(goalValue);
  }

  /// Biometric
  static Future<void> updateUsingBiometric(bool useBiometric) async {
    await _prefs?.setBool('use_biometric', useBiometric);
  }

  static Future<bool> checkUsingBiometric() async {
    return await _prefs?.getBool('use_biometric') ?? false;
  }

  /// ----------------------------- AVERAGE VALUES -----------------------------

  static Future<void> updateUsingAverageValue(bool isUsingAverageValue) async {
    await _prefs?.setBool('isUsingAverageValue', isUsingAverageValue);
  }

  static Future<bool> isUsingAverageValue() async {
    return await _prefs?.getBool('isUsingAverageValue') ?? false;
  }

  /// Average Mestruation length
  static Future<void> updateAverageMenstruationLength(int cycleLength) async {
    await _prefs?.setInt('averageMenstruationLength', cycleLength);
  }

  static Future<int> getAverageMenstruationLength() async {
    return await _prefs?.getInt('averageMenstruationLength') ?? getMenstruationLength();
  }

  /// Average Cycle length
  static Future<void> updateAverageCycleLength(int cycleLength) async {
    await _prefs?.setInt(_averageCycle, cycleLength);
  }

  static Future<int> getAverageCycleLength() async {
    return await _prefs?.getInt(_averageCycle) ?? getCycleLength();
  }

  static Future<void> saveSkippedVersion(String version) async {
    await _prefs?.setString(_skipVersionKey, version);
  }

  static Future<String?> getSkippedVersion() async {
    return await _prefs?.getString(_skipVersionKey);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
