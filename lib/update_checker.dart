import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum UpdateStatus { none, optional, force }

class UpdateChecker {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --- Lấy version mới nhất (string) giữa force & optional ---
  Future<String?> getLatestVersion() async {
    try {
      final doc = await _firestore.collection('app_config').doc('version').get();
      final data = doc.data() ?? {};
      final forceV = (data['force_version'] ?? '').toString().trim();
      final optionalV = (data['optional_version'] ?? '').toString().trim();

      if (forceV.isEmpty && optionalV.isEmpty) return null;
      if (forceV.isEmpty) return optionalV;
      if (optionalV.isEmpty) return forceV;

      return compareVersions(forceV, optionalV) >= 0 ? forceV : optionalV;
    } catch (e) {
      print("❌ getLatestVersion error: $e");
      return null;
    }
  }

  /// --- Kiểm tra trạng thái update hiện tại ---
  Future<UpdateStatus> checkForUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final doc = await _firestore.collection('app_config').doc('version').get();
      final data = doc.data() ?? {};
      final forceV = (data['force_version'] ?? '').toString().trim();
      final optionalV = (data['optional_version'] ?? '').toString().trim();

      if (forceV.isNotEmpty && isVersionLower(currentVersion, forceV)) {
        return UpdateStatus.force;
      }
      if (optionalV.isNotEmpty && isVersionLower(currentVersion, optionalV)) {
        return UpdateStatus.optional;
      }
      return UpdateStatus.none;
    } catch (e) {
      print("❌ checkForUpdate error: $e");
      return UpdateStatus.none;
    }
  }

  /// --- Mở store ---
  Future<void> openStore({String? androidPackage, String? iosAppId}) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final packageName = androidPackage ?? info.packageName;

      final url = Platform.isIOS
          ? 'https://apps.apple.com/app/id${iosAppId ?? "<APP_ID>"}'
          : 'https://play.google.com/store/apps/details?id=$packageName';

      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print("❌ openStore error: $e");
    }
  }

  // ===== Helpers =====

  /// So sánh version dạng string "x.y.z..." theo từng segment
  /// Trả về:
  /// -1 nếu a < b
  /// 0 nếu a == b
  /// 1 nếu a > b
  int compareVersions(String a, String b) {
    final ap = a.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final bp = b.split('.').map((s) => int.tryParse(s) ?? 0).toList();
    final n = ap.length > bp.length ? ap.length : bp.length;

    for (var i = 0; i < n; i++) {
      final av = i < ap.length ? ap[i] : 0;
      final bv = i < bp.length ? bp[i] : 0;
      if (av != bv) return av < bv ? -1 : 1;
    }
    return 0;
  }

  /// Kiểm tra a < b
  bool isVersionLower(String a, String b) => compareVersions(a, b) < 0;
}
