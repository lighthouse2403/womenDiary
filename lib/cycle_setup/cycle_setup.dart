import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_bloc.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_event.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_state.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:intl/intl.dart';

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

class _CycleSetupContent extends StatefulWidget {
  const _CycleSetupContent();

  @override
  State<_CycleSetupContent> createState() => _CycleSetupContentState();
}

class _CycleSetupContentState extends State<_CycleSetupContent> {
  double _cycleLength = 30;
  double _menstruationLength = 6;
  DateTime _lastPeriodDate = DateTime.now();

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
              BlocListener<CycleSetupBloc, CycleSetupState>(
                listenWhen: (_, current) => current is UpdatedCycleLengthState,
                listener: (_, state) {
                  setState(() {
                    _cycleLength = (state as UpdatedCycleLengthState).cycleLength.toDouble();
                  });
                },
              ),
              BlocListener<CycleSetupBloc, CycleSetupState>(
                listenWhen: (_, current) => current is UpdatedMenstruationLengthState,
                listener: (_, state) {
                  setState(() {
                    _menstruationLength = (state as UpdatedMenstruationLengthState).menstruationLength.toDouble();
                  });
                },
              ),
              BlocListener<CycleSetupBloc, CycleSetupState>(
                listenWhen: (_, current) => current is UpdatedLastPeriodDateState,
                listener: (_, state) {
                  setState(() {
                    _lastPeriodDate = (state as UpdatedLastPeriodDateState).date;
                  });
                },
              ),
            ],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Constants.vSpacer20,
                _buildTitleSection(),
                Constants.vSpacer30,
                _buildCycleLengthSlider(),
                Constants.vSpacer30,
                _buildMenstruationLengthSlider(),
                Constants.vSpacer30,
                _buildLastPeriodDatePicker(),
                Constants.vSpacer30,
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chào mừng bạn 💖",
          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink),
        ),
        SizedBox(height: 8),
        Text(
          "Hãy thiết lập chu kỳ để bắt đầu theo dõi.",
          style: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  Widget _buildCycleLengthSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Độ dài chu kỳ (ngày):", style: TextStyle(fontSize: 14)),
        Slider(
          value: _cycleLength,
          min: 20,
          max: 120,
          divisions: 100,
          label: "${_cycleLength.toInt()}",
          activeColor: Colors.pinkAccent,
          onChanged: (value) {
            setState(() => _cycleLength = value);
            context.read<CycleSetupBloc>().add(CycleLengthChangedEvent(value.toInt()));
          },
        ),
        Center(
          child: Text(
            "${_cycleLength.toInt()} ngày",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildMenstruationLengthSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Độ dài kỳ kinh (ngày):", style: TextStyle(fontSize: 14)),
        Slider(
          value: _menstruationLength,
          min: 2,
          max: 10,
          divisions: 8,
          label: "${_menstruationLength.toInt()} ngày",
          activeColor: Colors.deepOrangeAccent,
          onChanged: (value) {
            setState(() => _menstruationLength = value);
            context.read<CycleSetupBloc>().add(MenstruationLengthChangedEvent(value.toInt()));
          },
        ),
        Text(
          "${_menstruationLength.toInt()} ngày",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildLastPeriodDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Ngày bắt đầu kỳ kinh gần nhất:", style: TextStyle(fontSize: 14)),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: _lastPeriodDate,
              firstDate: DateTime.now().subtract(const Duration(days: 365)),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null) {
              setState(() => _lastPeriodDate = selectedDate);
              context.read<CycleSetupBloc>().add(LastPeriodDateChangedEvent(selectedDate));
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
                Text(DateFormat('dd/MM/yyyy').format(_lastPeriodDate),
                    style: const TextStyle(fontSize: 16)),
                const Icon(Icons.calendar_today, color: Colors.pinkAccent),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
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
