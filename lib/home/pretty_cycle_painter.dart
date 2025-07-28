import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:women_diary/home/phase_model.dart';

class PrettyCyclePainter extends CustomPainter {
  final int currentDay;
  final int totalDays;
  final List<PhaseModel> phases;
  final double rotation;
  final int ovulationDay;

  PrettyCyclePainter({
    required this.currentDay,
    required this.totalDays,
    required this.phases,
    required this.rotation,
    required this.ovulationDay,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final strokeWidth = size.width * 0.12;
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final dotRadiusBase = size.width * 0.009;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    int dayIndex = 0;

    // Vẽ từng giai đoạn với màu đậm, không gradient
    for (final phase in phases) {
      final sweep = 2 * pi * phase.days / totalDays;
      paint.color = phase.color;
      canvas.drawArc(arcRect, startAngle, sweep, false, paint);
      startAngle += sweep;
    }

    // Vẽ từng chấm tròn cho mỗi ngày
    startAngle = -pi / 2;
    for (final phase in phases) {
      for (int j = 0; j < phase.days; j++) {
        final angle = startAngle + j * 2 * pi / totalDays + pi / totalDays;
        final dotOffset = Offset(
          center.dx + cos(angle) * radius,
          center.dy + sin(angle) * radius,
        );

        final isCurrent = (dayIndex + 1 == currentDay);
        final isOvulation = (dayIndex + 1 == ovulationDay);

        final scale = isCurrent ? 1.5 + sin(rotation * 2 * pi) * 0.2 : 1.0;
        final dotRadius = isCurrent ? dotRadiusBase * 2.2 * scale : dotRadiusBase;

        // Ripple effect cho ngày hiện tại
        if (isCurrent) {
          final rippleRadius = dotRadius * 2.8 + sin(rotation * 2 * pi) * 2.5;
          canvas.drawCircle(
            dotOffset,
            rippleRadius,
            Paint()
              ..color = const Color.fromRGBO(255, 255, 255, 0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }

        // Dot chính
        canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);

        // Border cho ngày hiện tại
        if (isCurrent) {
          canvas.drawCircle(
            dotOffset,
            dotRadius,
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );

          final span = TextSpan(
            text: '${dayIndex + 1}',
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1,
            ),
          );
          final tp = TextPainter(
            text: span,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, dotOffset - Offset(tp.width / 2, tp.height / 2));
        }

        // Biểu tượng rụng trứng
        if (isOvulation) {
          final tp = TextPainter(
            text: const TextSpan(
              text: '🥚',
              style: TextStyle(fontSize: 16),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, dotOffset - Offset(tp.width / 2, tp.height / 2));
        }

        dayIndex++;
      }

      startAngle += 2 * pi * phase.days / totalDays;
    }
  }

  @override
  bool shouldRepaint(covariant PrettyCyclePainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
          oldDelegate.phases != phases ||
          oldDelegate.currentDay != currentDay ||
          oldDelegate.ovulationDay != ovulationDay;
}
