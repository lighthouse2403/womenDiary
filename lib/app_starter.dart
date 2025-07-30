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
  bool _authFailed = false;
  Timer? _timeoutTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startAuthenticationWithTimeout();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _startAuthenticationWithTimeout() {
    if (!widget.useBiometric) {
      setState(() => _unlocked = true);
      return;
    }

    _authFailed = false;
    _unlocked = false;

    // Bắt đầu timeout
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 5), () {
      if (!_unlocked && mounted) {
        setState(() => _authFailed = true); // Hiện nút xác thực lại
      }
    });

    // Delay nhẹ tránh resume quá sớm
    Future.delayed(const Duration(milliseconds: 300), _authenticate);
  }

  void _onAppResumed() {
    if (widget.useBiometric && !_unlocked) {
      _startAuthenticationWithTimeout();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _onAppResumed();
    }
  }

  Future<void> _authenticate() async {
    if (_authInProgress) return;

    _authInProgress = true;
    try {
      final canCheck = await _auth.canCheckBiometrics;
      final isSupported = await _auth.isDeviceSupported();

      if (!canCheck || !isSupported) {
        setState(() {
          _authFailed = true;
          _unlocked = false;
        });
        return;
      }

      final didAuth = await _auth.authenticate(
        localizedReason: 'Xác thực bằng Face ID hoặc Touch ID để tiếp tục',
        options: const AuthenticationOptions(
          stickyAuth: true, // Cho phép hiển thị màn hình passcode máy
          biometricOnly: false, // Cho phép fallback passcode
          useErrorDialogs: true,
        ),
      );

      if (didAuth) {
        _timeoutTimer?.cancel();
        setState(() {
          _unlocked = true;
          _authFailed = false;
        });
      } else {
        setState(() {
          _unlocked = false;
          _authFailed = true;
        });
      }
    } catch (e) {
      debugPrint('Lỗi xác thực: $e');
      setState(() {
        _unlocked = false;
        _authFailed = true;
      });
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
                const Icon(Icons.lock_outline, size: 64, color: Colors.grey),
                const SizedBox(height: 20),
                const Text('Ứng dụng đã bị khoá', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                if (_authInProgress)
                  const CircularProgressIndicator()
                else if (_authFailed)
                  ElevatedButton.icon(
                    onPressed: _authenticate,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Xác thực lại'),
                  )
                else
                  const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      );
    }

    // Nếu đã xác thực thành công thì hiển thị app chính
    return MaterialApp.router(
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: Routes.generateRouter(RoutesName.home),
    );
  }
}
