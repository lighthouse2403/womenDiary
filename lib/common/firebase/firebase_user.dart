import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';

class FirebaseUser {
  FirebaseUser._();

  static final instance = FirebaseUser._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addUser() async {
    CollectionReference users = firestore.collection('user');
    List<String> deviceInfo = await getDeviceDetails();
    var docSnapshot = await users.doc(deviceInfo[3]).get();
    if (!docSnapshot.exists) {
      users.doc(deviceInfo[3]).set({
        'os': deviceInfo.firstOrNull,
        'deviceName': deviceInfo[1],
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
    String identifier = '';
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.utsname.nodename;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    return [os, deviceName, deviceVersion, identifier];
  }
}