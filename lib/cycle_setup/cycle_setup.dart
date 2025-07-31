import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/cycle_setup/bloc/cycle_setup_bloc.dart';

class FirstCycleSetupScreen extends StatelessWidget {
  const FirstCycleSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleSetupBloc(),
      child: const FirstCycleSetupView(),
    );
  }
}

class FirstCycleSetupView extends StatelessWidget {
  const FirstCycleSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: BlocConsumer<CycleSetupBloc, CycleSetupState>(
            listenWhen: (prev, current) => current.submitted && !prev.submitted,
            listener: (context, state) {
              // Navigate to home or show success
              Navigator.pushReplacementNamed(context, '/home');
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Chào mừng bạn 💖",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.pink),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Hãy thiết lập chu kỳ để bắt đầu theo dõi.",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),

                  const Text("Độ dài chu kỳ (ngày):", style: TextStyle(fontSize: 14)),
                  Slider(
                    value: state.cycleLength.toDouble(),
                    min: 20,
                    max: 40,
                    divisions: 20,
                    label: state.cycleLength.toString(),
                    activeColor: Colors.pinkAccent,
                    onChanged: (value) {
                      context.read<CycleSetupBloc>().add(CycleLengthChanged(value.toInt()));
                    },
                  ),
                  Center(
                    child: Text(
                      "${state.cycleLength} ngày",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text("Độ dài kỳ kinh (ngày):", style: TextStyle(fontSize: 14)),
                  Slider(
                    value: state.menstruationLength.toDouble(),
                    min: 2,
                    max: 10,
                    divisions: 8,
                    label: state.menstruationLength.toString(),
                    activeColor: Colors.deepOrangeAccent,
                    onChanged: (value) {
                      context.read<CycleSetupBloc>().add(MenstruationLengthChanged(value.toInt()));
                    },
                  ),
                  Center(
                    child: Text(
                      "${state.menstruationLength} ngày",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CycleSetupBloc>().add(SubmitCycleSetup());
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
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
