import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/setting/bloc/setting_bloc.dart';
import 'package:women_diary/setting/bloc/setting_event.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: 'Cài đặt'),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          children: [
            _title("🎀 Cài đặt chu kỳ"),
            _cycleSlider(),
            _menstruationSlider(),
            _title("🩷 "),
            _averageSwitch(),
            _title("🔐 Bảo mật"),
            _pin(),
            _title("🎯 Mục tiêu của bạn"),
            _goalSegmented(),
            SizedBox(height: 20),
            Center(
              child: Text(
                "💖 Designed for women\nwith love and care",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CupertinoColors.systemGrey,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _title(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.label,
        ),
      ),
    );
  }

  Widget _cycleSlider() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateCycleLengthState,
      builder: (context, state) {
        int length = (state as UpdateCycleLengthState).value;
        return SliderTile(
          label: "Độ dài chu kỳ",
          value: length,
          min: 20,
          max: 40,
          onChanged: (v) => context.read<SettingBloc>().add(UpdateCycleLengthEvent(v)),
        );
      },
    );
  }

  Widget _goalSegmented() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateGoalState,
      builder: (context, state) {
        UserGoal goal = (state as UpdateGoalState).goal;

        return CupertinoSlidingSegmentedControl<UserGoal>(
          groupValue: goal,
          children: const {
            UserGoal.avoidPregnancy: Text("Tránh thai"),
            UserGoal.tryingToConceive: Text("Muốn có thai"),
          },
          onValueChanged: (value) {
            if (value != null) {
              context.read<SettingBloc>().add(UpdateUserGoal(value));
            }
          },
        );
      },
    );
  }

  Widget _pin() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateUsingPINState,
      builder: (context, state) {
        bool isEnabled = (state as UpdateUsingPINState).isUsingPIN;
        return SwitchTile(
          label: "Bật mã PIN khi mở app",
          value: isEnabled,
          onChanged: (val) => context.read<SettingBloc>().add(TogglePinEnabled(val)),
        );
      },
    );
  }

  Widget _averageSwitch() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateUsingAverageState,
      builder: (context, state) {
        bool isEnabled = (state as UpdateUsingAverageState).isUsingAverage;

        return SwitchTile(
          label: "Sử dụng giá trị trung bình",
          value: isEnabled,
          onChanged: (val) => context.read<SettingBloc>().add(ToggleAverageEvent(val)),
        );
      },
    );
  }

  Widget _menstruationSlider() {
    return BlocBuilder<SettingBloc, SettingState>(
      buildWhen: (previous, current) => current is UpdateMenstruationLengthState,
      builder: (context, state) {
        int menstruationLength = (state as UpdateMenstruationLengthState).value;
        return SliderTile(
          label: "Số ngày hành kinh",
          value: menstruationLength,
          min: 1,
          max: 10,
          onChanged: (v) => context.read<SettingBloc>().add(UpdateMenstruationLengthEvent(v)),
        );
      },
    );
  }
}

