import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
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
      create: (_) => HomeBloc()..add(LoadCycleEvent()),
      child: const HomeView(),
    );
  }
}


class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  late Animation<double> _fadeAnimation;
  late AnimationController _alertController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // NEW: init alert animation
    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _animation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
      _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _alertController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _alertController, curve: Curves.easeIn));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertController.forward();
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          List<PhaseModel> phases = state is LoadedCycleState ? state.phases : [];
          int currentDay = state is LoadedCycleState ? state.currentDay : 0;
          int cycleLength = state is LoadedCycleState ? state.cycleLength : 30;
          int daysUntilNext = state is LoadedCycleState ? state.daysUntilNext : 30;
          int ovulationDay = cycleLength - 14;

          final screenWidth = MediaQuery.of(context).size.width;
          final padding = 60.0;
          final width = screenWidth - padding;

          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: Size(width, width),
                  painter: PrettyCyclePainter(
                    currentDay: currentDay,
                    totalDays: cycleLength,
                    phases: phases, rotation: 0.6,
                    ovulationDay: ovulationDay,
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: GestureDetector(
                    onTap: () {
                      _controller.stop();
                      _showCycleDialog();
                    },
                    child: _cycleInformation(currentDay, cycleLength, daysUntilNext),
                  ),
                ),
                if (daysUntilNext <= 3)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: _cycleAlertCard(context),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cycleInformation(int currentDay, int cycleLength, int daysUntilNext) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(90),
        border: Border.all(color: Colors.white70, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ngày hiện tại").text14().customColor(Colors.black54),
          Text("Ngày ${currentDay}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          Constants.vSpacer4,
          Text("Chu kỳ ${cycleLength} ngày", style: const TextStyle(fontSize: 12, color: Colors.black45)),
          Constants.vSpacer6,
          Text("Giai đoạn: 🌼", style: const TextStyle(fontSize: 12, color: Colors.black87)),
          Constants.vSpacer4,
          Text("Tiếp theo: 🌙", style: const TextStyle(fontSize: 12, color: Colors.deepOrange)),
          Text("Còn ${daysUntilNext} ngày", style: const TextStyle(fontSize: 12, color: Colors.orange)),
        ],
      ),
    );
  }

  void _showCycleDialog() {
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
  }

  Widget _cycleAlertCard(BuildContext context) {
    final state = context.read<HomeBloc>().state;
    final hasStarted = state is LoadedCycleState ? state.daysUntilNext < 3 : false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.pink, size: 20),
              SizedBox(width: 8),
              Text(
                "Sắp đến chu kỳ mới",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.pink),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Hãy xác nhận để theo dõi chu kỳ chính xác hơn.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          hasStarted
              ? ElevatedButton.icon(
            icon: const Text("🧘‍♀️", style: TextStyle(fontSize: 18)),
            label: const Text("Kết thúc kỳ kinh"),
            style: ElevatedButton.styleFrom(
              animationDuration: const Duration(milliseconds: 300),
              elevation: 4,
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              side: BorderSide(color: Colors.pink.shade300),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<HomeBloc>().add(EndMenstruationEvent());
            },
          )
              : ElevatedButton.icon(
            icon: const Text("🌸", style: TextStyle(fontSize: 18)),
            label: const Text("Bắt đầu chu kỳ mới"),
            style: ElevatedButton.styleFrom(
              animationDuration: const Duration(milliseconds: 300),
              elevation: 4,
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<HomeBloc>().add(StartNewCycleEvent());
            },
          ),
        ],
      ),
    );
  }
}
