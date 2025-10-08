import 'dart:io';
import 'dart:math' as Math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'dart:ui' as ui;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';

class FirebaseUser {
  FirebaseUser._();

  static final instance = FirebaseUser._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    CollectionReference users = firestore.collection('user');
    Map<String, dynamic> deviceInfo = await getFullDeviceInfo();
    var docSnapshot = await users.doc(deviceInfo[2]).get();
    final cycleLength = await LocalStorageService.getCycleLength();
    final averageCycleLength = await DatabaseHandler.getAverageCycleLength();
    var menstruationLength = await LocalStorageService.getMenstruationLength();

    if (!docSnapshot.exists) {
      users.doc(deviceInfo['uuid']).set({
        'uuid': deviceInfo['uuid'],
        'os': deviceInfo['os'],
        'cycle': cycleLength,
        'menstruation': menstruationLength,
        'averageCycle': averageCycleLength,
        'region': deviceInfo['region'],
        'language': deviceInfo['language'],
        'appVersion': deviceInfo['appVersion'],
        'wifiIP': deviceInfo['wifiIP'],
        'deviceName': deviceInfo['deviceName'],
        'modelCode': deviceInfo['modelCode'],
        'modelName': deviceInfo['modelName'],
        'totalDiskSize': deviceInfo['totalDiskSize'],
        'freeDiskSize': deviceInfo['freeDiskSize'],
        'goal': deviceInfo['goal'],
        'screenWidth': deviceInfo['screenWidth'],
        'screenHeight': deviceInfo['screenHeight'],
        'screenScale': deviceInfo['screenScale'],
        'aspectRatio': deviceInfo['aspectRatio'],
        'firstTime': FieldValue.serverTimestamp()
      }).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      updateLastTime();
    }
  }

  Future<void> updateLastTime() async {
    CollectionReference users = firestore.collection('user');
    Map<String, dynamic> deviceInfo = await getFullDeviceInfo();
    users.doc(deviceInfo['uuid'])
        .update({'lastTime' : FieldValue.serverTimestamp(), 'os': deviceInfo['os']})
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

  Future<Map<String, dynamic>> getFullDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final networkInfo = NetworkInfo();
    final locale = ui.PlatformDispatcher.instance.locale;
    final packageInfo = await PackageInfo.fromPlatform();
    var goal = await LocalStorageService.getGoal();

    String identifier = await LocalStorageService.getUuid();
    final screen = ui.PlatformDispatcher.instance.views.first;

    String? ip;

    try {
      ip = await networkInfo.getWifiIP();
    } catch (_) {}

    Map<String, dynamic> deviceData = {
      'os': '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      'language': locale.languageCode,
      'region': locale.countryCode,
      'appVersion': '${packageInfo.version} (${packageInfo.buildNumber})',
      'wifiIP': ip,
      'screenWidth': screen.physicalSize.width / screen.devicePixelRatio,
      'screenHeight': screen.physicalSize.height / screen.devicePixelRatio,
      'screenScale': screen.devicePixelRatio,
      'aspectRatio': (screen.physicalSize.width / screen.physicalSize.height),
      'goal': goal.valueString
    };

    if (Platform.isAndroid) {
      if (identifier.isEmpty) {
        identifier = await Uuid().v6();
        LocalStorageService.updateUuid(identifier);
      }
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceData.addAll({
        'uuid': identifier,
        'deviceName': androidInfo.device, // hardware codename
        'modelCode': androidInfo.model, // ví dụ Pixel 7 Pro
        'totalDiskSize': _formatBytes(androidInfo.totalDiskSize),
        'freeDiskSize': _formatBytes(androidInfo.freeDiskSize),
        'manufacturer': androidInfo.manufacturer,
        'sdkInt': androidInfo.version.sdkInt,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceData.addAll({
        'uuid': iosInfo.identifierForVendor,
        'deviceName': iosInfo.name,
        'modelCode': iosInfo.utsname.machine, // ví dụ iPhone12,1
        'totalDiskSize': _formatBytes(iosInfo.totalDiskSize),
        'freeDiskSize': _formatBytes(iosInfo.freeDiskSize),
        'modelName': iosInfo.modelName,
      });
    }

    return deviceData;
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (Math.log(bytes) / Math.log(1024)).floor();
    final size = (bytes / Math.pow(1024, i)).toStringAsFixed(decimals);
    return "$size ${suffixes[i]}";
  }
}
