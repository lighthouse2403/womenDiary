import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:uuid/uuid.dart';
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
    var cycleLength = LocalStorageService.getCycleLength();
    var averageCycleLength = LocalStorageService.getAverageCycleLength();
    var menstruationLength = LocalStorageService.getMenstruationLength();
    var averageMenstruationLength = LocalStorageService.getAverageMenstruationLength();

    if (!docSnapshot.exists) {
      users.doc(deviceInfo['uuid']).set({
        'uuid': deviceInfo['uuid'],
        'os': deviceInfo['os'],
        'cycle': cycleLength,
        'menstruation': menstruationLength,
        'averageCycle': averageCycleLength,
        'averageMenstruation': averageMenstruationLength,
        'region': deviceInfo['region'],
        'language': deviceInfo['language'],
        'appVersion': deviceInfo['appVersion'],
        'wifiIP': deviceInfo['wifiIP'],
        'wifiSSID': deviceInfo['wifiSSID'],
        'model': deviceInfo['model'],
        'totalDiskSize': deviceInfo['totalDiskSize'],
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
    String identifier = LocalStorageService.getUuid();
    String? ssid;
    String? ip;

    try {
      ssid = await networkInfo.getWifiName();
      ip = await networkInfo.getWifiIP();
    } catch (_) {
      ssid = null;
      ip = null;
    }

    Map<String, dynamic> deviceData = {
      'os': '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
      'language': locale.languageCode,
      'region': locale.countryCode,
      'appVersion': '${packageInfo.version} (${packageInfo.buildNumber})',
      'wifiSSID': ssid,
      'wifiIP': ip,
    };

    if (Platform.isAndroid) {
      if (identifier.isEmpty) {
        identifier = await Uuid().v6();
        LocalStorageService.updateUuid(identifier);
      }
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceData.addAll({
        'uuid': identifier,
        'model': androidInfo.model,
        'totalDiskSize': androidInfo.totalDiskSize,
        'freeDiskSize': androidInfo.freeDiskSize,
        'manufacturer': androidInfo.manufacturer,
        'sdkInt': androidInfo.version.sdkInt,
      });
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceData.addAll({
        'uuid': iosInfo.identifierForVendor,
        'model': iosInfo.modelName,
        'totalDiskSize': iosInfo.totalDiskSize,
        'freeDiskSize': iosInfo.freeDiskSize,
      });
    }

    return deviceData;
  }
}
