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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _runSecurityCheck();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _runSecurityCheck();
    }
  }

  Future<void> _runSecurityCheck() async {
    // 1. Kiểm tra xem người dùng có bật biometric không
    final biometricEnabled = await LocalStorageService.checkUsingBiometric();

    if (biometricEnabled) {
      final bioSuccess = await BiometricService().authenticate();
      if (!bioSuccess) {
        setState(() => _unlocked = false);
        return;
      }
    }

    // 2. Check update
    final updateStatus = await UpdateChecker().checkForUpdate();
    if (updateStatus != UpdateStatus.none) {
      _showUpdateDialog(updateStatus);
      return;
    }

    // 3. Nếu qua hết các bước, unlock app
    setState(() => _unlocked = true);
  }

  void _showUpdateDialog(UpdateStatus status) {
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
            style: const TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
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
                  setState(() => _unlocked = true);
                },
                child: const Text('Để sau'),
              ),
            TextButton(
              onPressed: () {
                _openStore();
              },
              child: const Text('Cập nhật ngay'),
            ),
          ],
        );
      },
    );
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

    return FutureBuilder<String>(
      future: _determineInitialRoute(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        final initialRoute = snapshot.data!;
        final router = Routes.generateRouter(initialRoute);

        return MaterialApp.router(
          themeMode: ThemeMode.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        );
      },
    );
  }

  Future<String> _determineInitialRoute() async {
    final cycleLength = await LocalStorageService.getCycleLength();
    final menstruationLength = await LocalStorageService.getMenstruationLength();
    final shouldStart = cycleLength == 0 || menstruationLength == 0;
    return shouldStart ? RoutesName.firstCycleInformation : RoutesName.home;
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

}
