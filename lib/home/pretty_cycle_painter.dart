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
    final progressWidth = size.width * 0.12; // dày hơn, tỷ lệ theo màn hình
    final outerRadius = size.width / 2 - 10;
    final innerRadius = outerRadius - progressWidth;
    final middleRadius = outerRadius;

    final arcRect = Rect.fromCircle(center: center, radius: outerRadius);

    double startAngle = -pi / 2;
    int dayIndex = 0;

    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressWidth
      ..strokeCap = StrokeCap.round;

    for (final phase in phases) {
      final sweep = 2 * pi * phase.days / totalDays;

      // Vẽ vùng progress
      arcPaint.shader = SweepGradient(
        startAngle: startAngle,
        endAngle: startAngle + sweep,
        colors: [phase.color.withAlpha(100), phase.color.withAlpha(200)],
      ).createShader(arcRect);
      canvas.drawArc(arcRect, startAngle, sweep, false, arcPaint);

      // Vẽ emoji và số ngày
      final midAngle = startAngle + sweep / 2;
      final labelOffset = Offset(
        center.dx + cos(midAngle) * (innerRadius - 8),
        center.dy + sin(midAngle) * (innerRadius - 8),
      );
      _drawText(canvas, "${phase.emoji}\n${phase.days} ngày", labelOffset);

      // Vẽ các chấm nhỏ mỗi ngày
      for (int i = 0; i < phase.days; i++) {
        final angle = startAngle + i * 2 * pi / totalDays + pi / totalDays;
        final dotOffset = Offset(
          center.dx + cos(angle) * middleRadius,
          center.dy + sin(angle) * middleRadius,
        );

        final isCurrent = (dayIndex + 1 == currentDay);

        final dotRadius = isCurrent ? 10.0 : 2.0;

        if (isCurrent) {
          // Vẽ viền ngoài to
          canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);
          canvas.drawCircle(
              dotOffset,
              dotRadius,
              Paint()
                ..color = Colors.black
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1);

          // Vẽ số ngày
          final span = TextSpan(
            text: '${dayIndex + 1}',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1,
            ),
          );
          final tp = TextPainter(text: span, textAlign: TextAlign.center, textDirection: TextDirection.ltr);
          tp.layout();
          tp.paint(canvas, dotOffset - Offset(tp.width / 2, tp.height / 2));
        } else {
          canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);
        }

        dayIndex++;
      }

      startAngle += sweep;
    }
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
