import 'dart:math';

import 'package:flutter/material.dart';
import 'package:women_diary/home/phase_model.dart';

class PrettyCyclePainter extends CustomPainter {
  final int currentDay;
  final int totalDays;
  final List<PhaseModel> phases;

  PrettyCyclePainter({
    required this.currentDay,
    required this.totalDays,
    required this.phases,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final outerRadius = size.width / 2 - 16;
    final innerRadius = outerRadius - 30;
    final arcRect = Rect.fromCircle(center: center, radius: outerRadius);

    double startAngle = -pi / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28
      ..strokeCap = StrokeCap.round;

    for (final phase in phases) {
      final sweep = 2 * pi * phase.days / totalDays;
      paint.shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweep,
        colors: [phase.color.withAlpha(110), phase.color.withAlpha(220)],
      ).createShader(arcRect);
      canvas.drawArc(arcRect, startAngle, sweep, false, paint);

      final midAngle = startAngle + sweep / 2;
      final labelOffset = Offset(
        center.dx + cos(midAngle) * innerRadius,
        center.dy + sin(midAngle) * innerRadius,
      );
      _drawText(canvas, "${phase.emoji}\n${phase.days} ngày", labelOffset);

      startAngle += sweep;
    }

    final angle = 2 * pi * currentDay / totalDays - pi / 2;
    final indicatorOffset = Offset(
      center.dx + cos(angle) * outerRadius,
      center.dy + sin(angle) * outerRadius,
    );
    canvas.drawCircle(indicatorOffset, 6, Paint()..color = Colors.redAccent);
  }

  void _drawText(Canvas canvas, String text, Offset offset) {
    final span = TextSpan(
      text: text,
      style: const TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
    );
    final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    tp.layout();
    canvas.save();
    canvas.translate(offset.dx - tp.width / 2, offset.dy - tp.height / 2);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}