import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;
  String cycleLengthKey = 'cycleLength';
  String useCertainCycleLength = 'useCertainCycleLength';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Using certain cycle
  static Future<void> useCertainCycle(bool value) async {
    await _prefs?.setBool('useCertainCycleLength', value);
  }

  /// Cycle length
  static Future<void> updateCycleLength(int cycleLength) async {
    await _prefs?.setInt('cycleLength', cycleLength);
  }

  static Future<void> updateMenstrualLength(int menstrualLength) async {
    await _prefs?.setInt('menstrualLength', menstrualLength);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
