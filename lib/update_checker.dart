import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Kiểm tra trạng thái update
  Future<UpdateStatus> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = int.parse(packageInfo.version.replaceAll('.', ''));

    print(currentVersion);
    final doc = await _firestore.collection('app_config').doc('version').get();
    final forceUpdateVersion = doc['force_version'] ?? 0;
    final optionalUpdateVersion = doc['optional_version'] ?? 0;

    if (forceUpdateVersion > currentVersion) {
      return UpdateStatus.force;
    } else if (optionalUpdateVersion > currentVersion) {
      return UpdateStatus.optional;
    }
    return UpdateStatus.none;
  }

  /// Mở Store tương ứng với nền tảng
  Future<void> openStore() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    final url = Platform.isIOS
        ? 'https://apps.apple.com/app/id<APP_ID>'
        : 'https://play.google.com/store/apps/details?id=babyDiary';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

enum UpdateStatus { none, optional, force }
