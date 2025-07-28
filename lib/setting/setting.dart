import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/setting/bloc/setting_event.dart';
import 'package:women_diary/setting/bloc/setting_state.dart';
import 'bloc/setting_bloc.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SettingBloc(),
      child: const _SettingView(),
    );
  }
}

class _SettingView extends StatelessWidget {
  const _SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Cài đặt"),
      ),
      child: SafeArea(
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            final bloc = context.read<SettingBloc>();

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              children: [
                _section("🎀 Cài đặt chu kỳ"),
                _sliderTile(
                  "Độ dài chu kỳ",
                  state.cycleLength,
                  20,
                  40,
                      (val) => bloc.add(UpdateCycleLength(val)),
                ),
                _sliderTile(
                  "Số ngày hành kinh",
                  state.menstruationLength,
                  1,
                  10,
                      (val) => bloc.add(UpdateMenstruationLength(val)),
                ),
                _section("🩷 Ngày rụng trứng"),
                _switchTile(
                  "Sử dụng ngày cố định",
                  state.useFixedOvulation,
                      (val) => bloc.add(ToggleFixedOvulation(val)),
                ),
                if (state.useFixedOvulation)
                  _sliderTile(
                    "Chọn ngày rụng trứng",
                    state.ovulationDay,
                    10,
                    20,
                        (val) => bloc.add(UpdateOvulationDay(val)),
                  ),
                _section("🔐 Bảo mật"),
                _switchTile(
                  "Bật mã PIN khi mở app",
                  state.isPinEnabled,
                      (val) => bloc.add(TogglePinEnabled(val)),
                ),
                _section("🎯 Mục tiêu của bạn"),
                CupertinoSlidingSegmentedControl<UserGoal>(
                  groupValue: state.goal,
                  children: const {
                    UserGoal.avoidPregnancy: Text("Tránh thai"),
                    UserGoal.tryingToConceive: Text("Muốn có thai"),
                  },
                  onValueChanged: (goal) {
                    if (goal != null) {
                      bloc.add(UpdateUserGoal(goal));
                    }
                  },
                ),
                const SizedBox(height: 40),
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
            );
          },
        ),
      ),
    );
  }

  Widget _section(String title) {
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

  Widget _sliderTile(
      String label, int value, int min, int max, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CupertinoSlider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              const SizedBox(width: 10),
              Text("$value ngày",
                  style: const TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
      String label, bool value, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.label,
                )),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            inactiveTrackColor: CupertinoColors.systemPink,
          ),
        ],
      ),
    );
  }
}
