import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateChecker {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Kiểm tra trạng thái update
  Future<UpdateStatus> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = packageInfo.version;

    final doc = await _firestore.collection('app_config').doc('version').get();
    final forceUpdateVersion = doc['force_version'] ?? '';
    final optionalUpdateVersion = doc['optional_version'] ?? '';

    if (_isVersionLower(currentVersion, forceUpdateVersion)) {
      return UpdateStatus.force;
    } else if (_isVersionLower(currentVersion, optionalUpdateVersion)) {
      return UpdateStatus.optional;
    }
    return UpdateStatus.none;
  }

  /// So sánh version theo dạng 1.2.3
  bool _isVersionLower(String current, String target) {
    if (target.isEmpty) return false;

    final currentParts = current.split('.').map(int.parse).toList();
    final targetParts = target.split('.').map(int.parse).toList();

    for (int i = 0; i < targetParts.length; i++) {
      if (currentParts.length <= i) return true; // thiếu số version → thấp hơn
      if (currentParts[i] < targetParts[i]) return true;
      if (currentParts[i] > targetParts[i]) return false;
    }
    return false;
  }

  /// Mở Store tương ứng với nền tảng
  Future<void> openStore() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;

    final url = Platform.isIOS
        ? 'https://apps.apple.com/app/id<APP_ID>' // TODO: thay <APP_ID> bằng App Store ID
        : 'https://play.google.com/store/apps/details?id=$packageName';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}

enum UpdateStatus { none, optional, force }
