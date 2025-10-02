import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

/// Bridge gọi GDPR plugin native (Swift)
class GDPRPlugin {
  static const MethodChannel _channel = MethodChannel('gdpr_plugin');

  static Future<Map<String, dynamic>> getGDPRValues() async {
    final Map values = await _channel.invokeMethod('getGDPRValues');
    return values.map((key, value) => MapEntry(key.toString(), value));
  }
}

/// AdsHelper với check GDPR + ATT + Google Ads
class AdsHelper {
  static InterstitialAd? _interstitialAd;
  static double _lastDisplayingTime = 0;
  static bool _canShowAds = false;

  /// Khởi tạo: check ATT, GDPR rồi load ads
  static Future<void> init() async {
    // iOS: xin ATT (App Tracking Transparency)
    if (Platform.isIOS) {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    }

    try {
      if (Platform.isIOS) {
        final gdprData = await GDPRPlugin.getGDPRValues();
        _canShowAds = _evaluateGDPR(gdprData);
      } else {
        _canShowAds = true;
      }
    } catch (e) {
      print("GDPR check error: $e");
      _canShowAds = true; // fallback
    }

    // Init Google Mobile Ads
    await MobileAds.instance.initialize();
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: <String>['2319471873f7024999e7933a8a89954b']),
    );

    if (_canShowAds) {
      loadInterstitialAd();
    }
  }

  /// Hiển thị interstitial ad
  static void showAd({required Function onDismiss}) {
    if (!_canShowAds) {
      onDismiss();
      return;
    }

    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

    if (_interstitialAd == null) {
      onDismiss();
      loadInterstitialAd();
      return;
    }

    if ((currentTime - _lastDisplayingTime) > 18) {
      _lastDisplayingTime = currentTime;

      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          loadInterstitialAd();
          onDismiss();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
          onDismiss();
        },
      );

      _interstitialAd?.show();
      _interstitialAd = null;
    } else {
      onDismiss();
    }
  }

  /// Load Interstitial ad
  static void loadInterstitialAd() {
    if (!_canShowAds) return;

    _interstitialAd = null;

    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
          print("InterstitialAd failed: $err");
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Chọn ad unit id theo platform
  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-7356825362262138/4701299628";
    } else if (Platform.isIOS) {
      return "ca-app-pub-7356825362262138/5194228222";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  /// Logic check GDPR (chuyển từ Swift sang Dart)
  static bool _evaluateGDPR(Map<String, dynamic> gdprData) {
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

    return hasConsentForPurpose1 && hasConsentOrLI;
  }
}
