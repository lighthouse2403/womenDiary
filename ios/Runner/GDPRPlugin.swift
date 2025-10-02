import Flutter
import UIKit

public class GDPRPlugin: NSObject, FlutterPlugin {
    
    // Hàm này Flutter gọi khi plugin được đăng ký
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "gdpr_plugin",
            binaryMessenger: registrar.messenger()
        )
        let instance = GDPRPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    // Xử lý các method call từ Flutter
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Method: \(call.method)")
        switch call.method {
        case "getGDPRValues":
            getGDPRValues(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    // Hàm đọc dữ liệu GDPR từ UserDefaults
    private func getGDPRValues(result: @escaping FlutterResult) {
        let settings = UserDefaults.standard
        
        let purposeConsent = settings.string(forKey: "IABTCF_PurposeConsents") ?? ""
        let vendorConsent = settings.string(forKey: "IABTCF_VendorConsents") ?? ""
        let purposeLI = settings.string(forKey: "IABTCF_PurposeLegitimateInterests") ?? ""
        let vendorLI = settings.string(forKey: "IABTCF_VendorLegitimateInterests") ?? ""
        let gdprApplies = settings.integer(forKey: "IABTCF_gdprApplies")
        
        let values: [String: Any] = [
            "purposeConsent": purposeConsent,
            "vendorConsent": vendorConsent,
            "purposeLI": purposeLI,
            "vendorLI": vendorLI,
            "gdprApplies": gdprApplies
        ]
        
        result(values)
    }
}
