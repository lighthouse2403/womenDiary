import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/database/data_handler.dart';
import 'package:women_diary/database/local_storage_service.dart';
import 'package:women_diary/setting/bloc/setting_bloc.dart';
import 'package:women_diary/setting/bloc/setting_event.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';
import 'package:women_diary/setting/pin_input.dart';
import 'package:women_diary/setting/slider_title.dart';
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
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = info.version;
    });
  }

  Future<void> _contactDeveloper() async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'developer@example.com',
      query: 'subject=Hỗ trợ ứng dụng Women Diary',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Cài đặt').w600().text18().whiteColor().ellipsis(),
        backgroundColor: AppColors.pinkTextColor,
        leading: InkWell(
          onTap: () async {
            final cycleLength = LocalStorageService.isUsingAverageValue()
                ? await DatabaseHandler.getAverageCycleLength()
                : LocalStorageService.getCycleLength();
            CycleModel lastCycle = await DatabaseHandler.getLastCycle();
            DateTime cycleEndTime = lastCycle.cycleStartTime.add(Duration(days: cycleLength - 1));

            lastCycle.cycleEndTime = cycleEndTime;
            DatabaseHandler.updateCycle(lastCycle);

            context.pop();
          },
          child: Align(
            alignment: Alignment.center,
            child: Assets.icons.arrowBack.svg(
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)
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
              title: "🎀 Chu kỳ",
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
              title: "🔐 Bảo mật",
              children: [
                _pin(context),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.flag,
              color: Colors.amber.shade400,
              title: "🎯 Mục tiêu",
              children: [
                _goalSegmented(),
              ],
            ),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.info,
              color: Colors.blue.shade400,
              title: "ℹ️ Thông tin",
              children: [
                ListTile(
                  leading: const Icon(Icons.phone_android, color: Colors.blue),
                  title: const Text("Phiên bản ứng dụng"),
                  trailing: Text(_appVersion.isEmpty ? "..." : _appVersion).w600(),
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text("Liên hệ nhà phát triển"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: _contactDeveloper,
                ),
                ListTile(
                  leading: const Icon(Icons.science, color: Colors.deepPurple),
                  title: const Text("Cơ sở khoa học tính chu kỳ"),
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
              child: Text(
                "💖 Designed for women\nwith love and care",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Reuse card UI
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  // Bloc UI giữ nguyên
  Widget _cycleSlider() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateCycleLengthState,
      builder: (context, state) {
        int length = (state is UpdateCycleLengthState) ? state.value : 30;
        return _styledSlider(
          label: "Độ dài chu kỳ",
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
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: (color ?? Colors.pink).withAlpha(30),
                  child: Icon(icon, color: color ?? Colors.pink),
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  "$value ngày",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.systemPink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: color ?? Colors.pink,
                inactiveTrackColor: (color ?? Colors.pink).withAlpha(50),
                thumbColor: color ?? Colors.pink,
                overlayColor: (color ?? Colors.pink).withAlpha(30),
                trackHeight: 6,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
              ),
              child: Slider(
                value: value.toDouble(),
                min: min.toDouble(),
                max: max.toDouble(),
                divisions: max - min,
                onChanged: (v) => onChanged(v.round()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalSegmented() => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateGoalState,
    builder: (context, state) {
      UserGoal goal = (state is UpdateGoalState)
          ? state.goal
          : UserGoal.avoidPregnancy;

      return CupertinoSlidingSegmentedControl<UserGoal>(
        groupValue: goal,
        thumbColor: Colors.pink.shade200,
        backgroundColor: Colors.pink.shade50,
        children: const {
          UserGoal.avoidPregnancy: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text("Tránh thai"),
          ),
          UserGoal.tryingToConceive: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text("Muốn có thai"),
          ),
        },
        onValueChanged: (value) {
          if (value != null) {
            context.read<SettingBloc>().add(UpdateUserGoal(value));
          }
        },
      );
    },
  );

  Widget _pin(BuildContext context) => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateUsingBiometricState,
    builder: (context, state) {
      final isEnabled = state is UpdateUsingBiometricState
          ? state.isUsingBiometric
          : false;
      return SwitchTile(
        label: "Sử dụng Face ID",
        value: isEnabled,
        onChanged: (value) async {
          context
              .read<SettingBloc>()
              .add(UpdateUsingBiometricEvent(value));
        },
      );
    },
  );

  Widget _averageSwitch() => BlocBuilder<SettingBloc, SettingState>(
    buildWhen: (previous, current) => current is UpdateUsingAverageState,
    builder: (context, state) {
      bool isEnabled =
      (state is UpdateUsingAverageState) ? state.isUsingAverage : false;
      int avgLength = (state is UpdateUsingAverageState) ? state.averageCycle : 30;

      print('avgLength: ${avgLength}');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SwitchTile(
            label: "Sử dụng giá trị trung bình",
            value: isEnabled,
            onChanged: (val) =>
                context.read<SettingBloc>().add(ToggleAverageEvent(val)),
          ),
          if (avgLength > 0) // chỉ hiển thị khi có dữ liệu
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                "Giá trị trung bình hiện tại: $avgLength ngày",
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
        ],
      );
    },
  );
}
