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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkSecurityAndInit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkSecurityAndInit();
    }
  }

  Future<void> _checkSecurityAndInit() async {
    // 1. Check biometric if enabled
    final biometricEnabled = await LocalStorageService.checkUsingBiometric();
    if (biometricEnabled) {
      final bioSuccess = await BiometricService().authenticate();
      if (!bioSuccess) {
        setState(() {
          _unlocked = false;
          _initialRoute = null;
        });
        return;
      }
    }

    print('_checkSecurityAndInit -- checkForUpdate');
    // 2. Check update
    final updateStatus = await UpdateChecker().checkForUpdate();
    print('updateStatus ${updateStatus}');

    if (updateStatus != UpdateStatus.none) {
      setState(() {
        _pendingUpdate = updateStatus;
      });
      return; // không unlock ngay, chờ dialog xử lý
    }

    print('_checkSecurityAndInit -- _determineInitialRoute');

    // 3. Determine initial route
    final route = await _determineInitialRoute();
    if (mounted) {
      setState(() {
        _unlocked = true;
        _initialRoute = route;
      });
    }
  }

  Future<String> _determineInitialRoute() async {
    final cycleLength = await LocalStorageService.getCycleLength();
    final menstruationLength = await LocalStorageService.getMenstruationLength();
    final shouldStart = cycleLength == 0 || menstruationLength == 0;
    return shouldStart
        ? RoutesName.firstCycleInformation
        : RoutesName.home;
  }

  Future<void> _openStore() async {
    String url;
    if (Platform.isAndroid) {
      url = 'https://play.google.com/store/apps/details?id=com.example.app';
    } else if (Platform.isIOS) {
      url = 'https://apps.apple.com/app/id1234567890';
    } else {
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Không thể mở store');
    }
  }

  void _showUpdateDialog(UpdateStatus status) {
    if (!mounted) return;
    print('_showUpdateDialog');
    showDialog(
      context: context,
      barrierDismissible: status != UpdateStatus.force,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.pink[50],
          title: Text(
            status == UpdateStatus.force
                ? 'Cập nhật bắt buộc'
                : 'Có bản cập nhật mới',
            style: const TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Phiên bản mới mang lại nhiều cải tiến và trải nghiệm tốt hơn cho bạn.',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            if (status == UpdateStatus.optional)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _finishUnlock();
                },
                child: const Text('Để sau'),
              ),
            TextButton(
              onPressed: _openStore,
              child: const Text('Cập nhật ngay'),
            ),
          ],
        );
      },
    );
  }

  void _finishUnlock() async {
    final route = await _determineInitialRoute();
    if (mounted) {
      setState(() {
        _unlocked = true;
        _initialRoute = route;
        _pendingUpdate = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_pendingUpdate != null) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (ctx) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showUpdateDialog(_pendingUpdate!);
            });
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          },
        ),
      );
    }

    if (!_unlocked || _initialRoute == null) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return MaterialApp.router(
      themeMode: ThemeMode.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: Routes.generateRouter(_initialRoute!),
    );
  }


  RouterConfig<Object> _loadingRouter() {
    return Routes.generateRouter(RoutesName.home);
  }
}
