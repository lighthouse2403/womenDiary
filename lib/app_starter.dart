import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:women_diary/biometric_service.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/l10n/app_localizations.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/update_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppStarter extends StatefulWidget {
  const AppStarter({super.key});

  @override
  State<AppStarter> createState() => _AppStarterState();
}

class _AppStarterState extends State<AppStarter> with WidgetsBindingObserver {
  bool _unlocked = false;
  String? _initialRoute;

  UpdateStatus? _pendingUpdate;
  String? _pendingVersion;
  String? _shownVersion; // version đã show popup để optional không lặp
  bool _forceUpdateActive = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bootstrap(); // check lại khi quay lại app
    }
  }

  Future<void> _bootstrap() async {
    if (_unlocked) {
      await _checkUpdate();
      return;
    }

    final canProceed = await _checkBiometric();
    if (!canProceed) return;

    await _checkUpdate();
    await _unlockApp();
  }

  Future<bool> _checkBiometric() async {
    final enabled = await LocalStorageService.checkUsingBiometric();
    if (!enabled) return true;

    final ok = await BiometricService().authenticate();
    if (!ok) {
      if (!mounted) return false;
      setState(() {
        _unlocked = false;
        _initialRoute = null;
      });
      return false;
    }
    return true;
  }

  Future<void> _checkUpdate() async {
    final status = await UpdateChecker().checkForUpdate();
    final latestVersion = await UpdateChecker().getLatestVersion();

    if (!mounted) return;
    if (status != UpdateStatus.none) {
      setState(() {
        _pendingUpdate = status;
        _pendingVersion = latestVersion;
      });
    } else {
      setState(() {
        _pendingUpdate = null;
        _pendingVersion = null;
      });
    }
  }

  Future<void> _unlockApp() async {
    final route = await _determineInitialRoute();
    if (!mounted) return;
    setState(() {
      _unlocked = true;
      _initialRoute = route;
    });
  }

  Future<String> _determineInitialRoute() async {
    final cycle = await LocalStorageService.getCycleLength();
    final menstruation = await LocalStorageService.getMenstruationLength();
    return (cycle == 0 || menstruation == 0)
        ? RoutesName.firstCycleInformation
        : RoutesName.home;
  }

  void _maybeShowUpdatePopup(BuildContext materialContext) {
    if (_pendingUpdate == null || _pendingVersion == null) return;
    if (_pendingUpdate == UpdateStatus.optional &&
        _pendingVersion == _shownVersion) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final isForce = _pendingUpdate == UpdateStatus.force;
      _forceUpdateActive = isForce;

      showDialog(
        context: materialContext,
        barrierDismissible: !isForce,
        barrierColor: Colors.pink.shade100.withAlpha(100),
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 48, color: Colors.pink),
                  const SizedBox(height: 12),
                  Text(
                    isForce ? "🌸 Cập nhật bắt buộc!" : "🌸 Có phiên bản mới!",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isForce
                        ? "Phiên bản này bắt buộc cập nhật để tiếp tục sử dụng 💖"
                        : "Cập nhật ngay để trải nghiệm mượt mà hơn 💖",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (!isForce)
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.pink,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            UpdateChecker().skipVersion();
                            Navigator.pop(context);
                            _shownVersion = _pendingVersion; // bỏ qua optional version này
                          },
                          child: const Text("Để sau"),
                        ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          UpdateChecker().openStore();
                        },
                        child: const Text("Cập nhật"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_unlocked || _initialRoute == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: Routes.generateRouter(_initialRoute!),
      builder: (materialContext, child) {
        _maybeShowUpdatePopup(materialContext);
        return child!;
      },
    );
  }
}
