import 'package:flutter/material.dart';
import 'dart:math';

import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/home/pretty_cycle_painter.dart';

class AnimatedCycleView extends StatefulWidget {
  final List<PhaseModel> phases;
  final int totalDays;
  final int currentDay;

  const AnimatedCycleView({
    super.key,
    required this.phases,
    required this.totalDays,
    required this.currentDay,
  });

  @override
  State<AnimatedCycleView> createState() => _AnimatedCycleViewState();
}

class _AnimatedCycleViewState extends State<AnimatedCycleView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // Lặp vô hạn để tạo hiệu ứng xoay gradient
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.9;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.square(width),
          painter: PrettyCyclePainter(
            currentDay: widget.currentDay,
            totalDays: widget.totalDays,
            phases: widget.phases,
            rotation: _controller.value * 2 * pi, // chuyển thành radian
          ),
          // ⚠️ repaint bằng controller để vẽ lại liên tục
          isComplex: true,
          willChange: true,
        );
      },
    );
  }
}
