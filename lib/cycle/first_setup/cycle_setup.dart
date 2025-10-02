import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/widgets/date_picker/custom_date_picker.dart' as FeminineDateTimePicker;
import 'package:women_diary/cycle/first_setup/bloc/cycle_setup_bloc.dart';
import 'package:women_diary/cycle/first_setup/bloc/cycle_setup_event.dart';
import 'package:women_diary/cycle/first_setup/bloc/cycle_setup_state.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class FirstCycleSetupView extends StatelessWidget {
  const FirstCycleSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleSetupBloc(),
      child: const _CycleSetupContent(),
    );
  }
}

class _CycleSetupContent extends StatelessWidget {
  const _CycleSetupContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: MultiBlocListener(
            listeners: [
              BlocListener<CycleSetupBloc, CycleSetupState>(
                listenWhen: (prev, current) => current is SavedCycleInformationState,
                listener: (context, state) {
                  context.navigateTo(RoutesName.home);
                },
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constants.vSpacer20,
                _buildTitleSection(),
                Constants.vSpacer30,
                _CycleLengthSlider(),
                Constants.vSpacer30,
                _MenstruationLengthSlider(),
                Constants.vSpacer30,
                _LastPeriodDatePicker(),
                Constants.vSpacer30,
                _SubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Chào mừng bạn 💖").text24().pinkColor().w600(),
        SizedBox(height: 8),
        Text("Hãy thiết lập chu kỳ để bắt đầu theo dõi.").text16().black87Color(),
      ],
    );
  }
}

class _CycleLengthSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CycleSetupBloc, CycleSetupState>(
      buildWhen: (pre,cur) => cur is UpdatedCycleLengthState,
      builder: (context, state) {
        int cycleLength = state is UpdatedCycleLengthState ? state.cycleLength : 30;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Độ dài chu kỳ (ngày):")
                .text14()
                .w600()
                .pinkColor(),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 6,
                thumbShape:
                const RoundSliderThumbShape(enabledThumbRadius: 12),
                overlayShape:
                const RoundSliderOverlayShape(overlayRadius: 20),
                activeTrackColor: Colors.pinkAccent,
                inactiveTrackColor: Colors.pink.shade100,
                thumbColor: Colors.pink,
                overlayColor: Colors.pink.withAlpha(50),
              ),
              child: Slider(
                value: cycleLength.toDouble(),
                min: 24,
                max: 120,
                divisions: 96,
                onChanged: (value) {
                  context
                      .read<CycleSetupBloc>()
                      .add(CycleLengthChangedEvent(value.toInt()));
                },
              ),
            ),

            const SizedBox(height: 8),

            // dòng kết quả + nút tăng giảm
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _CircleIconButton(
                  icon: Icons.remove,
                  onTap: () {
                    if (cycleLength > 24) {
                      context
                          .read<CycleSetupBloc>()
                          .add(CycleLengthChangedEvent(cycleLength - 1));
                    }
                  },
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade50,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pink.shade100.withAlpha(130),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: Text(
                    "$cycleLength ngày 🌸",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.pink,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                _CircleIconButton(
                  icon: Icons.add,
                  onTap: () {
                    if (cycleLength < 120) {
                      context
                          .read<CycleSetupBloc>()
                          .add(CycleLengthChangedEvent(cycleLength + 1));
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Nút tròn gradient xinh cho +/-
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade300, Colors.purple.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade100.withAlpha(150),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MenstruationLengthSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CycleSetupBloc, CycleSetupState>(
      buildWhen: (pre,cur) => cur is UpdatedMenstruationLengthState,
      builder: (context, state) {
        int menstruationLength = state is UpdatedMenstruationLengthState ? state.menstruationLength : 6;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Độ dài kỳ kinh (ngày):").text14(),
            Slider(
              value: menstruationLength.toDouble(),
              min: 2,
              max: 10,
              divisions: 8,
              label: "$menstruationLength ngày",
              activeColor: Colors.deepOrangeAccent,
              onChanged: (value) {
                context.read<CycleSetupBloc>().add(
                  MenstruationLengthChangedEvent(value.toInt()),
                );
              },
            ),
            Text("$menstruationLength ngày").text16().w600(),
          ],
        );
      },
    );
  }
}

class _LastPeriodDatePicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CycleSetupBloc, CycleSetupState>(
      buildWhen: (_, current) => current is UpdatedLastPeriodDateState,
      builder: (context, state) {
        final lastPeriodDate = (state is UpdatedLastPeriodDateState)
            ? state.date
            : context.read<CycleSetupBloc>().lastPeriodDate;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ngày bắt đầu kỳ kinh gần nhất:").text14(),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final selectedDate = await FeminineDateTimePicker.showFeminineDateTimePicker(
                  context: context,
                  initialDate: lastPeriodDate,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                  locale: const Locale('vi'),
                );
                if (selectedDate != null) {
                  context
                      .read<CycleSetupBloc>()
                      .add(LastPeriodDateChangedEvent(selectedDate));
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(lastPeriodDate.globalDateFormat()).text16(),
                    const Icon(Icons.calendar_today, color: Colors.pinkAccent),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          context.read<CycleSetupBloc>().add(const SubmitCycleInformationEvent());
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text("Bắt đầu theo dõi"),
      ),
    );
  }
}
