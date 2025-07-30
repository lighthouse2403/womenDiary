import 'dart:async';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:women_diary/l10n/app_localizations.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class AppStarter extends StatefulWidget {
  final bool useBiometric;
  const AppStarter({super.key, required this.useBiometric});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> with WidgetsBindingObserver {
  final LocalAuthentication _auth = LocalAuthentication();
  bool _unlocked = false;
  bool _authInProgress = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkBiometricOnLaunch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _checkBiometricOnLaunch() async {
    print('_checkBiometricOnLaunch ${widget.useBiometric}');
    if (!widget.useBiometric) {
      setState(() => _unlocked = true);
    } else {
      await _authenticate();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.useBiometric && state == AppLifecycleState.resumed) {
      _startTimeoutAndLock();
    }
  }

  void _startTimeoutAndLock() {
    setState(() => _unlocked = false);

    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!_unlocked) {
        debugPrint("Đã hết timeout 5s. Cho phép xác thực lại.");
      }
    });

    // Thêm delay nhỏ tránh resume quá nhanh
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted && !_unlocked) {
        _authenticate();
      }
    });
  }

  Future<void> _authenticate() async {
    if (_authInProgress) {
      debugPrint("Bỏ qua xác thực do đang trong quá trình trước đó.");
      return;
    }

    _authInProgress = true;
    debugPrint("Bắt đầu xác thực sinh trắc...");

    try {
      final canCheck = await _auth.canCheckBiometrics;
      final supported = await _auth.isDeviceSupported();

      if (!canCheck || !supported) {
        setState(() => _unlocked = true);
        _authInProgress = false;
        return;
      }

      final didAuth = await _auth.authenticate(
        localizedReason: 'Xác thực bằng vân tay hoặc Face ID để tiếp tục',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
          useErrorDialogs: true,
        ),
      );

      if (didAuth) {
        _timeoutTimer?.cancel();
        setState(() => _unlocked = true);
      } else {
        setState(() => _unlocked = false);
      }
    } catch (e) {
      debugPrint('Lỗi sinh trắc: $e');
      setState(() => _unlocked = false);
    } finally {
      _authInProgress = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 64, color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  'Ứng dụng đã bị khoá',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),
                _authInProgress
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Xác thực lại'),
                  onPressed: _authenticate,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: Routes.generateRouter(RoutesName.home),
    );
  }
}
