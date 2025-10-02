import 'package:flutter/services.dart';

class GDPRHelper {
  static const MethodChannel _channel = MethodChannel('gdpr_plugin');

  /// Lấy dữ liệu GDPR từ native iOS
  static Future<Map<String, dynamic>?> getGDPRValues() async {
    try {
      final result = await _channel.invokeMethod('getGDPRValues');
      print('result ${result}');
      if (result == null) return null;

      final map = Map<String, dynamic>.from(result as Map);
      print('map ${map}');

      return map;
    } on PlatformException catch (e) {
      print("GDPR check error: $e");
      return null;
    }
  }

  /// Logic check GDPR (dùng lại code bạn có)
  static bool evaluateGDPR(Map<String, dynamic> gdprData) {
    final purposeConsent = gdprData['purposeConsent'] ?? "";
    final vendorConsent = gdprData['vendorConsent'] ?? "";
    final purposeLI = gdprData['purposeLI'] ?? "";
    final vendorLI = gdprData['vendorLI'] ?? "";
    final gdprApplies = gdprData['gdprApplies'] == 1;

    if (!gdprApplies) return true;

    int googleId = 755;
    bool hasGoogleVendorConsent =
        vendorConsent.length >= googleId && vendorConsent[googleId - 1] == "1";
    bool hasGoogleVendorLI =
        vendorLI.length >= googleId && vendorLI[googleId - 1] == "1";

    // Must have consent for Purpose 1
    bool hasConsentForPurpose1 =
        purposeConsent.isNotEmpty && purposeConsent[0] == "1" && hasGoogleVendorConsent;

    // Must have consent or LI for purposes 2,7,9,10
    bool hasConsentOrLI = [2, 7, 9, 10].every((i) {
      bool consentOk =
          purposeConsent.length >= i && purposeConsent[i - 1] == "1" && hasGoogleVendorConsent;
      bool liOk = purposeLI.length >= i && purposeLI[i - 1] == "1" && hasGoogleVendorLI;
      return consentOk || liOk;
    });

    print('hasConsentForPurpose1 $hasConsentForPurpose1 hasConsentOrLI: $hasConsentOrLI');
    return hasConsentForPurpose1 && hasConsentOrLI;
  }
}
