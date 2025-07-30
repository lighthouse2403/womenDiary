import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricGate extends StatefulWidget {
  final VoidCallback onUnlock;

  const BiometricGate({super.key, required this.onUnlock});

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  final LocalAuthentication auth = LocalAuthentication();
  String? _error;

  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      final isAvailable = await auth.isDeviceSupported();

      if (canCheck && isAvailable) {
        final didAuth = await auth.authenticate(
          localizedReason: 'Xác thực bằng vân tay hoặc Face ID để tiếp tục',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );

        if (didAuth) {
          widget.onUnlock();
        } else {
          setState(() {
            _error = 'Xác thực thất bại';
          });
        }
      } else {
        setState(() {
          _error = 'Thiết bị không hỗ trợ sinh trắc học';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Lỗi xác thực: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _error != null
            ? Text(_error!, style: TextStyle(color: Colors.red))
            : CircularProgressIndicator(),
      ),
    );
  }
}
