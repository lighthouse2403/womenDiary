import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/cycle_progress/cycle_information.dart';
import 'package:women_diary/home/cycle_progress/pretty_cycle_painter.dart';
import 'package:women_diary/home/home_component/cycle_alert.dart';

class CycleProgress extends StatefulWidget {
  const CycleProgress({super.key});

  @override
  State<CycleProgress> createState() => _CycleProgressState();
}

class _CycleProgressState extends State<CycleProgress>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _alertController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _alertController, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _alertController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSelector<HomeBloc, HomeState, CycleData?>(
      selector: (state) => state.cycle,
      builder: (context, cycle) {
        if (cycle == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentDay = cycle.currentDay;
        final cycleLength = cycle.cycleLength;
        final daysUntilNext = cycle.daysUntilNext;
        final phases = cycle.phases;
        final ovulationDay = cycleLength - 14;

        final screenWidth = MediaQuery.of(context).size.width;
        final circleSize = screenWidth - 60.0;
        final remainDays = cycleLength - currentDay;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (remainDays <= 3)
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CycleAlert(remainDays: remainDays),
                  ),
                ),
              ),

            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: Size(circleSize, circleSize),
                    painter: PrettyCyclePainter(
                      currentDay: currentDay,
                      totalDays: cycleLength,
                      phases: phases,
                      rotation: 0.6,
                      ovulationDay: ovulationDay,
                    ),
                  ),
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: GestureDetector(
                      onTap: () {
                        _pulseController.stop();
                        _showCycleDialog(
                          currentDay: currentDay,
                          cycleLength: cycleLength,
                          daysUntilNext: daysUntilNext,
                        );
                      },
                      child: CycleInformation(
                        currentDay: currentDay,
                        cycleLength: cycleLength,
                        daysUntilNext: daysUntilNext,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCycleDialog({
    required int currentDay,
    required int cycleLength,
    required int daysUntilNext,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Thông tin giai đoạn"),
        content: Text(
          "Hôm nay là ngày $currentDay\n"
              "Chu kỳ dự kiến: $cycleLength ngày\n"
              "Còn $daysUntilNext ngày tới mốc tiếp theo.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _pulseController.repeat();
            },
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }
}
