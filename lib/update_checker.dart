import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateChecker {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  bool _isVersionLower(String current, String target) {
    if (target.isEmpty) return false;
    final currentParts = current.split('.').map(int.parse).toList();
    final targetParts = target.split('.').map(int.parse).toList();
    print(currentParts);
    print(targetParts);

    for (int i = 0; i < targetParts.length; i++) {
      if (currentParts.length <= i) return true;
      if (currentParts[i] < targetParts[i]) return true;
      if (currentParts[i] > targetParts[i]) return false;
    }
    return false;
  }
}

enum UpdateStatus { none, optional, force }
