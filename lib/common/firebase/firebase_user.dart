import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:women_diary/database/local_storage_service.dart';

class FirebaseUser {
  FirebaseUser._();

  static final instance = FirebaseUser._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    CollectionReference users = firestore.collection('user');
    List<String> deviceInfo = await getDeviceDetails();
    var docSnapshot = await users.doc(deviceInfo[3]).get();
    var cycleLength = LocalStorageService.getCycleLength();
    var averageCycleLength = LocalStorageService.getAverageCycleLength();
    var menstruationLength = LocalStorageService.getMenstruationLength();
    var averageMenstruationLength = LocalStorageService.getAverageMenstruationLength();

    if (!docSnapshot.exists) {
      users.doc(deviceInfo[3]).set({
        'os': deviceInfo.firstOrNull,
        'deviceName': deviceInfo[1],
        'cycle': cycleLength,
        'menstruation': menstruationLength,
        'averageCycle': averageCycleLength,
        'averageMenstruation': averageMenstruationLength,
        'deviceVersion': deviceInfo[2],
        'deviceId': deviceInfo[3],
        'firstTime': FieldValue.serverTimestamp()
      }).then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      updateLastTime();
    }
  }

  Future<void> updateLastTime() async {
    CollectionReference users = firestore.collection('user');
    List<String> deviceInfo = await getDeviceDetails();
    users.doc(deviceInfo[3])
        .update({'lastTime' : FieldValue.serverTimestamp()})
        .then((_) => print('Success'))
        .catchError((error) => print('Failed: $error'));
  }

  Future<List<String>> getDeviceDetails() async {
    String os = Platform.operatingSystem;
    String deviceName = '';
    String deviceVersion = '';
    String identifier = LocalStorageService.getUuid();
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.release;
        if (identifier.isEmpty) {
          identifier = await Uuid().v6();
          LocalStorageService.updateUuid(identifier);
        }
      } else if (Platform.isIOS) {
        final data = await deviceInfoPlugin.iosInfo;
        deviceName = data.modelName; // Tên thiết bị, ví dụ "iPhone"
        deviceVersion = data.systemVersion; // Phiên bản iOS, ví dụ "16.5"
        identifier = data.identifierForVendor ?? ''; // UUID ổn định
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return [os, deviceName, deviceVersion, identifier];
  }
}
