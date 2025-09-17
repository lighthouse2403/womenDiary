import 'dart:io';

import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (!isSupported || !canCheck) {
        return true;
      }

      final biometricOnly = Platform.isIOS ? false : true;
      final didAuthenticate = await _auth.authenticate(
        localizedReason: 'Xác thực để tiếp tục sử dụng ứng dụng',
        options: AuthenticationOptions(
          biometricOnly: biometricOnly,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
