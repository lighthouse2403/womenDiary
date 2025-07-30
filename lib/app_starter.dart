import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import 'main.dart';

class AppStarter extends StatefulWidget {
  final bool useBiometric;
  const AppStarter({super.key, required this.useBiometric});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> {
  bool _unlocked = false;
  final _auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _tryBiometric();
  }

  Future<void> _tryBiometric() async {
    if (!widget.useBiometric) {
      setState(() => _unlocked = true);
      return;
    }

    try {
      bool canCheck = await _auth.canCheckBiometrics;
      bool supported = await _auth.isDeviceSupported();
      if (canCheck && supported) {
        bool didAuth = await _auth.authenticate(
          localizedReason: 'Xác thực bằng vân tay hoặc Face ID để mở ứng dụng',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (didAuth) {
          setState(() => _unlocked = true);
        }
      }
    } catch (e) {
      debugPrint('Lỗi xác thực sinh trắc: $e');
      // fallback nếu có lỗi
      setState(() => _unlocked = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return WomenDiary();
  }
}
