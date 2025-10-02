import Flutter
import UIKit

public class GDPRPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "gdpr_plugin", binaryMessenger: registrar.messenger())
        let instance = GDPRPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "getGDPRValues" {
            let settings = UserDefaults.standard
// read the TCF / IAB keys - if your CMP uses different keys, adjust here
            let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
            let vendorConsent = settings.string(forKey: "IABTCF_VendorConsents") ?? ""
            let purposeLI = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
            let vendorLI = settings.string(forKey: "IABTCF_VendorLegitimateInterests") ?? ""
            let gdprApplies = settings.integer(forKey: "IABTCF_gdprApplies")

            result([
                "purposeConsent": purposeConsent,
                "vendorConsent": vendorConsent,
                "purposeLI": purposeLI,
                "vendorLI": vendorLI,
                "gdprApplies": gdprApplies
            ])
        } else {
            result(FlutterMethodNotImplemented)
        }
    }
}
