import 'dart:io';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:women_diary/common/ads/gdpr_helper.dart';

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
        final gdprValues = await GDPRHelper.getGDPRValues();
        if (gdprValues != null) {
          _canShowAds = GDPRHelper.evaluateGDPR(gdprValues);
        }
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
      print('can not show ads');
      onDismiss();
      return;
    }

    double currentTime = DateTime.now().millisecondsSinceEpoch / 1000;

    if (_interstitialAd == null) {
      print('_interstitialAd null');

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
          print('onAdDismissedFullScreenContent');

          onDismiss();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          loadInterstitialAd();
          print('onAdFailedToShowFullScreenContent');

          onDismiss();
        },
      );
      print('show()');

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
      return "ca-app-pub-7356825362262138/9683755885";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
