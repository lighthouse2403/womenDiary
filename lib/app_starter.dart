import 'dart:io';
import 'package:flutter/material.dart';
import 'package:women_diary/biometric_service.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/l10n/app_localizations.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/update_checker.dart';
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
  bool _updateShown = false; // tránh mở dialog lặp lại

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
      _bootstrap(); // quay lại app thì check lại (sẽ mở lại popup nếu force)
    }
  }

  Future<void> _bootstrap() async {
    // 1) Biometric
    final canProceed = await _checkBiometric();
    if (!canProceed) return;

    // 2) Update
    await _checkUpdate(); // chỉ set _pendingUpdate, không chặn unlock

    // 3) Determine route và unlock
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
    if (!mounted) return;
    if (status != UpdateStatus.none) {
      // có update → đánh dấu để hiển thị popup sau khi UI render xong
      setState(() {
        _pendingUpdate = status;
        _updateShown = false;
      });
    } else {
      setState(() {
        _pendingUpdate = null;
        _updateShown = false;
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

  Future<void> _openStore() async {
    final url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.example.app'
        : Platform.isIOS
        ? 'https://apps.apple.com/app/id1234567890'
        : null;

    if (url == null) return;

    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw Exception('Không thể mở store');
    }
  }

  void _maybeShowUpdatePopup(BuildContext materialContext) {
    if (_pendingUpdate == null || _updateShown) return;
    _updateShown = true; // đánh dấu trước để tránh mở nhiều lần

    // Đảm bảo chạy sau frame hiện tại để context đã nằm bên trong MaterialApp
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        barrierColor: Colors.pink.shade100.withOpacity(0.4),
        builder: (context) {
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
                  const Icon(Icons.auto_awesome, size: 48, color: Colors.pink),
                  const SizedBox(height: 12),
                  const Text(
                    "🌸 Có phiên bản mới!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Cập nhật ngay để trải nghiệm trọn vẹn và mượt mà hơn 💖",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.pink, // màu chữ
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // bo nhẹ
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
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
    // Chưa unlock hoặc chưa có route → hiển thị loading (bên trong MaterialApp để có localizations)
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

    // Đã unlock: chạy app qua RouterConfig. Dùng builder để có context bên trong MaterialApp.
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: Routes.generateRouter(_initialRoute!),
      builder: (materialContext, child) {
        // nếu có update → mở popup đè lên UI (child là app chính)
        _maybeShowUpdatePopup(materialContext);
        return child!;
      },
    );
  }
}
