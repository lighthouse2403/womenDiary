// lib/setting/setting.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/app_bloc/app_bloc.dart';
import 'package:women_diary/app_bloc/app_event.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/context_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/setting/bloc/setting_bloc.dart';
import 'package:women_diary/setting/bloc/setting_event.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';
import 'package:women_diary/setting/switch_title.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingBloc()..add(LoadLocalDataEvent()),
      child: const SettingView(),
    );
  }
}

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  String _appVersion = "";

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = info.version;
        });
      }
    } catch (_) {
      // ignore errors, keep _appVersion empty
    }
  }

  Future<void> _contactDeveloper() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'developer@example.com',
      query: Uri(queryParameters: {
        'subject': 'Hỗ trợ ứng dụng Women Diary'
      }).query,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // Helper: update last cycle end time before popping (keeps your original logic)
  Future<void> _updateLastCycleAndPop(BuildContext context) async {
    int cycleLength = await LocalStorageService.isUsingAverageValue()
        ? await DatabaseHandler.getAverageCycleLength()
        : await LocalStorageService.getCycleLength();
    CycleModel lastCycle = await DatabaseHandler.getLastCycle();
    DateTime cycleEndTime = lastCycle.cycleStartTime.add(Duration(days: cycleLength - 1));
    lastCycle.cycleEndTime = cycleEndTime;
    await DatabaseHandler.updateCycle(lastCycle);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final language = context.language; // your extension

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text(language.settingTitle).w600().text18().whiteColor().ellipsis(),
        backgroundColor: AppColors.pinkTextColor,
        leading: InkWell(
          onTap: () => _updateLastCycleAndPop(context),
          child: Align(
            alignment: Alignment.center,
            child: Assets.icons.arrowBack.svg(
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          children: [
            _sectionCard(
              icon: Icons.favorite,
              color: Colors.pink.shade300,
              title: "🎀 ${language.cycleTitle}",
              children: [
                _cycleSlider(),
                _menstruationSlider(),
                _averageSwitch(),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.lock,
              color: Colors.purple.shade300,
              title: "🔐 ${language.settingTitle}", // keep consistent
              children: [
                _pin(context),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.flag,
              color: Colors.amber.shade400,
              title: "🎯 ${language.goalTitle}",
              children: [
                _goalSegmented(),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.language,
              color: Colors.teal.shade300,
              title: "🌍 ${language.languageSetting}",
              children: [
                _languagePicker(context),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.info,
              color: Colors.blue.shade400,
              title: "ℹ️ ${language.appInformation}",
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_android, color: Colors.blue),
                  title: Text(language.appVersion),
                  trailing: Text(_appVersion.isEmpty ? "..." : _appVersion).w600(),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: Text(language.contactUs),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _contactDeveloper,
                ),
                ListTile(
                  leading: const Icon(Icons.science, color: Colors.deepPurple),
                  title: Text(language.scientificEvidence),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () async {
                    final uri = Uri.parse(
                      "https://www.mayoclinic.org/healthy-lifestyle/womens-health/in-depth/menstrual-cycle/art-20047186",
                    );
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Text("💖 ${language.appSlogan}")
                  .text14()
                  .italic()
                  .customColor(CupertinoColors.systemGrey)
                  .center(),
            ),
          ],
        ),
      ),
    );
  }

  /// Reusable card UI
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 4,
      shadowColor: color.withAlpha(75),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withAlpha(50),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 10),
                Text(title).text17().w600().customColor(color),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // --- Cycle slider ---
  Widget _cycleSlider() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateCycleLengthState,
      builder: (context, state) {
        int length = (state is UpdateCycleLengthState) ? state.value : 30;
        return _styledSlider(
          label: context.language.cycleTitle,
          value: length,
          min: 20,
          max: 120,
          icon: Icons.autorenew,
          color: Colors.pinkAccent,
          onChanged: (v) => context.read<SettingBloc>().add(UpdateCycleLengthEvent(v)),
        );
      },
    );
  }

  // --- Menstruation slider ---
  Widget _menstruationSlider() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateMenstruationLengthState,
      builder: (context, state) {
        int menstruationLength = (state is UpdateMenstruationLengthState) ? state.value : 7;
        return _styledSlider(
          label: "Số ngày hành kinh",
          value: menstruationLength,
          min: 1,
          max: 10,
          icon: Icons.favorite,
          color: Colors.redAccent,
          onChanged: (v) => context.read<SettingBloc>().add(UpdateMenstruationLengthEvent(v)),
        );
      },
    );
  }

  Widget _styledSlider({
    required String label,
    required int value,
    required int min,
    required int max,
    required ValueChanged<int> onChanged,
    required IconData icon,
    Color? color,
  }) {
    final accent = color ?? Colors.pink;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: accent.withAlpha(30),
                  child: Icon(icon, color: accent),
                ),
                const SizedBox(width: 10),
                Expanded(child: Text(label).text16().w600()),
                const SizedBox(width: 10),
                Text('$value ngày')
                    .text15()
                    .w500()
                    .customColor(CupertinoColors.systemPink),
              ],
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: accent,
                inactiveTrackColor: accent.withAlpha(50),
                thumbColor: accent,
                overlayColor: accent.withAlpha(30),
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: value.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: (max - min),
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Goal segmented control ---
  Widget _goalSegmented() => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateGoalState,
    builder: (context, state) {
      UserGoal goal = (state is UpdateGoalState) ? state.goal : UserGoal.avoidPregnancy;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: CupertinoSlidingSegmentedControl<UserGoal>(
          groupValue: goal,
          thumbColor: Colors.pink.shade200,
          backgroundColor: Colors.pink.shade50,
          children: {
            UserGoal.avoidPregnancy: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(context.language.avoidPregnancy),
            ),
            UserGoal.tryingToConceive: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(context.language.tryingToConceive),
            ),
          },
          onValueChanged: (value) {
            if (value != null) {
              context.read<SettingBloc>().add(UpdateUserGoal(value));
            }
          },
        ),
      );
    },
  );

  // --- PIN / Biometric switch ---
  Widget _pin(BuildContext context) => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateUsingBiometricState,
    builder: (context, state) {
      final isEnabled = state is UpdateUsingBiometricState ? state.isUsingBiometric : false;
      return SwitchTile(
        label: "Sử dụng Face ID",
        value: isEnabled,
        onChanged: (value) => context.read<SettingBloc>().add(UpdateUsingBiometricEvent(value)),
      );
    },
  );

  // --- Average value switch ---
  Widget _averageSwitch() => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateUsingAverageState,
    builder: (context, state) {
      bool isEnabled = (state is UpdateUsingAverageState) ? state.isUsingAverage : false;
      int avgLength = (state is UpdateUsingAverageState) ? state.averageCycle : 30;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchTile(
            label: "Sử dụng giá trị trung bình",
            value: isEnabled,
            onChanged: (val) => context.read<SettingBloc>().add(ToggleAverageEvent(val)),
          ),
          if (avgLength > 0)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 6),
              child: Text("Giá trị trung bình hiện tại: $avgLength ngày").text14().greyColor().italic(),
            ),
        ],
      );
    },
  );

  // --- Language picker (fixed baseline issue & feminine style) ---
  Widget _languagePicker(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateLanguageState,
      builder: (context, state) {
        final currentLang = (state is UpdateLanguageState) ? state.languageId : "vi";
        final languages = Constants.languages;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: [Colors.pink.shade50, Colors.purple.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.pink.shade200, width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currentLang,
              isExpanded: true,
              icon: Icon(Icons.expand_more, color: Colors.pink.shade400),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.pink.shade900,
              ),
              dropdownColor: Colors.white,
              borderRadius: BorderRadius.circular(14),

              items: languages.entries.map((e) {
                return DropdownMenuItem<String>(
                  value: e.key,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    decoration: BoxDecoration(
                      color: e.key == currentLang
                          ? Colors.pink.shade50
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: e.key == currentLang
                          ? Border.all(color: Colors.pink.shade300, width: 1)
                          : null,
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        color: e.key == currentLang
                            ? Colors.pink.shade700
                            : Colors.grey.shade800,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),

              onChanged: (languageId) {
                if (languageId == null) return;
                context.read<SettingBloc>().add(UpdateLanguageIdEvent(languageId));
                context.read<AppBloc>().add(ChangeLanguageEvent(languageId));
              },
            ),
          ),
        );
      },
    );
  }
}
