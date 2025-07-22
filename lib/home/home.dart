import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/home/pretty_cycle_painter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()
        ..add(LoadCycleEvent(currentDay: 13, cycleLength: 28)),
      child: const HomeView(),
    );
  }
}


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        title: const Text('🌸 Chu kỳ dạng đồng hồ cute'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(320, 320),
                  painter: PrettyCyclePainter(
                    currentDay: 8,
                    totalDays: 40,
                    phases: [
                      PhaseModel("🩸", 5, Colors.pinkAccent, 6),
                      PhaseModel("🌱", 10, Colors.lightBlueAccent, 16),
                      PhaseModel("🌼", 1, Colors.yellowAccent, 17),
                      PhaseModel("🌙", 5, Colors.deepPurpleAccent, 22),
                    ],
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: GestureDetector(
                    onTap: () {
                      _controller.stop();
                      showDialog(
                        context: context,
                        builder: (dialogCtx) => AlertDialog(
                          title: const Text("Thông tin giai đoạn"),
                          content: Text(
                            "Hôm nay là ngày 12\n"
                                "Giai đoạn hiện tại: 🌱\n"
                                "Tiếp theo: 🌼 (trong 5 ngày)",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(dialogCtx).pop();
                                _controller.repeat();
                              },
                              child: const Text("Đóng"),
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(70),
                        border: Border.all(color: Colors.white70, width: 1.5),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Ngày hiện tại", style: TextStyle(fontSize: 14, color: Colors.black54)),
                          Text("Ngày 10", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text("Chu kỳ 8 ngày", style: const TextStyle(fontSize: 12, color: Colors.black45)),
                          const SizedBox(height: 6),
                          Text("Giai đoạn: 🌼", style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Text("Tiếp theo: 🌙", style: const TextStyle(fontSize: 12, color: Colors.deepOrange)),
                          Text("Còn 3 ngày", style: const TextStyle(fontSize: 12, color: Colors.orange)),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
