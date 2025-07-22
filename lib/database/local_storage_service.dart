import 'dart:ffi';

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

  static int getCycleLength() {
    return _prefs?.getInt('cycleLength') ?? 30;
  }

  /// Menstrual length
  static Future<void> updateMenstruationLength(int menstrualLength) async {
    await _prefs?.setInt('updateMenstruationLength', menstrualLength);
  }

  static int getMenstruationLength() {
    return _prefs?.getInt('updateMenstruationLength') ?? 7;
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
