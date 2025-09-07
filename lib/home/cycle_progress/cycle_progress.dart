import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
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
        final ovalutionDay = cycle.ovalutionDay;
        final remainDays = cycle.remainDays;
        final phases = cycle.phases;
        final currentPhase = cycle.currentPhase;
        final ovulationDay = cycleLength - 14;

        final screenWidth = MediaQuery.of(context).size.width;
        final circleSize = screenWidth - 60.0;
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
                          startDay: cycle.startDay,
                          endDay: cycle.endDay,
                          remainDays: remainDays,
                          ovalutionDay: ovalutionDay,
                        );
                      },
                      child: CycleInformation(
                        currentDay: currentDay,
                        cycleLength: cycleLength,
                        remainDays: remainDays,
                        phase: currentPhase,
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
    required DateTime startDay,
    required DateTime endDay,
    required DateTime ovalutionDay,
    required int remainDays,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [Colors.pink.shade50, Colors.purple.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.local_florist, size: 48, color: Colors.pink),
                const SizedBox(height: 12),
                const Text(
                  "🌸 Thông tin chu kỳ 🌸",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
                Constants.vSpacer20,
                _buildInfoRow("Hôm nay", "Ngày $currentDay"),
                Constants.vSpacer8,
                _buildInfoRow("Chu kỳ:", "$cycleLength ngày"),
                _buildInfoRow("Ngày bắt đầu", "${startDay.globalDateFormat()}"),
                Constants.vSpacer8,
                _buildInfoRow("Ngày kết thúc", "${endDay.globalDateFormat()}"),
                Constants.vSpacer8,
                _buildInfoRow("Ngày rụng trứng", "${ovalutionDay.globalDateFormat()}"),
                Constants.vSpacer8,
                _buildInfoRow("Kết thúc chu kỳ", "Trong $remainDays ngày"),
                Constants.vSpacer20,
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {
                    Navigator.of(dialogCtx).pop();
                    _pulseController.repeat();
                  },
                  child: const Text("Đóng"
                  ).w500().text14(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label).text14().w400(),
        Text(value).pinkColor().text14().w500(),
      ],
    );
  }

}
