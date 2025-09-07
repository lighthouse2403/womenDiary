import 'dart:math';
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
    final strokeWidth = 40.0;
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: radius);
    final dotRadiusBase = size.width * 0.009;

    final basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -pi / 2;
    int dayIndex = 0;

    // Vẽ các phase + border
    for (final phase in phases) {
      final sweep = 2 * pi * phase.days / totalDays;

      // Phase chính
      basePaint.color = phase.color;
      canvas.drawArc(arcRect, startAngle, sweep, false, basePaint);

      // 3. Glow pastel
      canvas.drawArc(
        arcRect,
        startAngle,
        sweep,
        false,
        Paint()
          ..color = phase.color.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5),
      );

      startAngle += sweep;
    }

    // Reset góc để vẽ dot từng ngày
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

        // Dot chính
        canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);

        if (isCurrent) {
          final rippleRadius = dotRadius * 2.8 + sin(rotation * 2 * pi) * 2.5;
          // Ripple effect
          canvas.drawCircle(
            dotOffset,
            rippleRadius,
            Paint()
              ..color = Colors.white.withAlpha(10)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6
              ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 6),
          );

          // Glow nền trắng mềm
          canvas.drawCircle(
            dotOffset,
            dotRadius * 2.6,
            Paint()
              ..color = Colors.white.withAlpha(150)
              ..style = PaintingStyle.fill
              ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
          );
        }

        canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);

        if (isCurrent) {
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

        // Biểu tượng rụng trứng ✨
        if (isOvulation) {
          final pulse = 1.0 + 0.15 * sin(rotation * 2 * pi);

          // Halo pastel
          canvas.drawCircle(
            dotOffset,
            dotRadius * 3.5 * pulse,
            Paint()
              ..color = Colors.pink.withAlpha(60)
              ..style = PaintingStyle.fill,
          );

          // Icon ✨
          final tp = TextPainter(
            text: const TextSpan(
              text: '✨',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
          );
          tp.layout();
          tp.paint(canvas, dotOffset - Offset(tp.width / 2, tp.height / 2));

          // Tia sáng
          final rays = 8;
          for (int i = 0; i < rays; i++) {
            final angle = (2 * pi / rays) * i;
            final start = Offset(
              dotOffset.dx + cos(angle) * (dotRadius * 2.3 * pulse),
              dotOffset.dy + sin(angle) * (dotRadius * 2.3 * pulse),
            );
            final end = Offset(
              dotOffset.dx + cos(angle) * (dotRadius * 3.2 * pulse),
              dotOffset.dy + sin(angle) * (dotRadius * 3.2 * pulse),
            );
            canvas.drawLine(
              start,
              end,
              Paint()
                ..color = Colors.amber.withOpacity(0.7)
                ..strokeWidth = 1.2
                ..strokeCap = StrokeCap.round,
            );
          }
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
