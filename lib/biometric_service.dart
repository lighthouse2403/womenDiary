import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final isAvailable = await _auth.canCheckBiometrics;
      if (!isAvailable) return true; // Nếu không có biometric → cho qua

      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Xác thực để tiếp tục sử dụng ứng dụng',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
