import 'dart:async';
import 'package:flutter/services.dart';

class GDPRValues {
  final String purposeConsent;
  final String vendorConsent;
  final String purposeLI;
  final String vendorLI;
  final int gdprApplies;

  GDPRValues({
    required this.purposeConsent,
    required this.vendorConsent,
    required this.purposeLI,
    required this.vendorLI,
    required this.gdprApplies,
  });
}

class GDPRHelper {
  static const MethodChannel _channel = MethodChannel('gdpr_plugin');

  static Future<GDPRValues> getGDPRValues() async {
    final Map<dynamic, dynamic>? map = await _channel.invokeMethod('getGDPRValues');
    if (map == null) {
      return GDPRValues(purposeConsent: '', vendorConsent: '', purposeLI: '', vendorLI: '', gdprApplies: 0);
    }
    return GDPRValues(
      purposeConsent: (map['purposeConsent'] ?? '') as String,
      vendorConsent: (map['vendorConsent'] ?? '') as String,
      purposeLI: (map['purposeLI'] ?? '') as String,
      vendorLI: (map['vendorLI'] ?? '') as String,
      gdprApplies: (map['gdprApplies'] ?? 0) as int,
    );
  }

// helpers to mimic your Swift logic
  static bool _hasAttribute(String input, int index) {
    return input.length >= index && input[index - 1] == '1';
  }

  static bool _hasConsentFor(List<int> purposes, String purposeConsent, bool hasVendorConsent) {
    return purposes.every((i) => _hasAttribute(purposeConsent, i)) && hasVendorConsent;
  }

  static bool _hasConsentOrLegitimateInterestFor(List<int> purposes, String purposeConsent, String purposeLI, bool hasVendorConsent, bool hasVendorLI) {
    return purposes.every((i) {
      return (_hasAttribute(purposeLI, i) && hasVendorLI) || (_hasAttribute(purposeConsent, i) && hasVendorConsent);
    });
  }

// Google vendor id from your Swift example
  static const int _googleId = 755;

  static Future<bool> canShowAds() async {
    final vals = await getGDPRValues();
    final purposeConsent = vals.purposeConsent;
    final vendorConsent = vals.vendorConsent;
    final vendorLI = vals.vendorLI;
    final purposeLI = vals.purposeLI;

    final hasGoogleVendorConsent = _hasAttribute(vendorConsent, _googleId);
    final hasGoogleVendorLI = _hasAttribute(vendorLI, _googleId);

    return _hasConsentFor([1], purposeConsent, hasGoogleVendorConsent) &&
        _hasConsentOrLegitimateInterestFor([2, 7, 9, 10], purposeConsent, purposeLI, hasGoogleVendorConsent, hasGoogleVendorLI);
  }

  static Future<bool> canShowPersonalizedAds() async {
    final vals = await getGDPRValues();
    final purposeConsent = vals.purposeConsent;
    final vendorConsent = vals.vendorConsent;
    final vendorLI = vals.vendorLI;
    final purposeLI = vals.purposeLI;

    final hasGoogleVendorConsent = _hasAttribute(vendorConsent, _googleId);
    final hasGoogleVendorLI = _hasAttribute(vendorLI, _googleId);

    return _hasConsentFor([1, 3, 4], purposeConsent, hasGoogleVendorConsent) &&
        _hasConsentOrLegitimateInterestFor([2, 7, 9, 10], purposeConsent, purposeLI, hasGoogleVendorConsent, hasGoogleVendorLI);
  }
}