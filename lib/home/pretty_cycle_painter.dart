import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:women_diary/home/phase_model.dart';

class PrettyCyclePainter extends CustomPainter {
  final int currentDay;
  final int totalDays;
  final List<PhaseModel> phases;
  final double rotation;

  PrettyCyclePainter({
    required this.currentDay,
    required this.totalDays,
    required this.phases,
    required this.rotation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final progressWidth = size.width * 0.12;
    final outerRadius = size.width / 2 - progressWidth / 2;
    final arcRect = Rect.fromCircle(center: center, radius: outerRadius);
    final dotRadiusBase = size.width * 0.009;

    double startAngle = -pi / 2;
    int dayIndex = 0;

    // Gradient toàn bộ vòng tròn chuyển động liên tục
    final fullGradient = SweepGradient(
      startAngle: 0,
      endAngle: 2 * pi,
      tileMode: TileMode.repeated,
      transform: GradientRotation(rotation * 2 * pi),
      colors: _buildFullGradientColors(phases),
      stops: _buildGradientStops(phases),
    );

    final Paint basePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = progressWidth
      ..strokeCap = StrokeCap.round
      ..shader = fullGradient.createShader(arcRect);

    // Vẽ từng phase như đoạn cắt trong vòng gradient
    for (int i = 0; i < phases.length; i++) {
      final phase = phases[i];
      final sweep = 2 * pi * phase.days / totalDays;

      canvas.drawArc(arcRect, startAngle, sweep, false, basePaint);

      // Emoji + số ngày
      final midAngle = startAngle + sweep / 2;
      final labelOffset = Offset(
        center.dx + cos(midAngle) * (outerRadius - progressWidth - 8),
        center.dy + sin(midAngle) * (outerRadius - progressWidth - 8),
      );
      _drawText(canvas, "${phase.emoji}\n${phase.days} ngày", labelOffset);

      // Dot từng ngày + ripple
      for (int j = 0; j < phase.days; j++) {
        final angle = startAngle + j * 2 * pi / totalDays + pi / totalDays;
        final dotOffset = Offset(
          center.dx + cos(angle) * outerRadius,
          center.dy + sin(angle) * outerRadius,
        );

        final isCurrent = (dayIndex + 1 == currentDay);
        final scale = isCurrent ? 1.5 + sin(rotation * 2 * pi) * 0.2 : 1.0;
        final dotRadius = isCurrent ? dotRadiusBase * 2.2 * scale : dotRadiusBase;

        // Ripple effect
        if (isCurrent) {
          final rippleRadius = dotRadius * 2.8 + sin(rotation * 2 * pi) * 2.5;
          canvas.drawCircle(
            dotOffset,
            rippleRadius,
            Paint()
              ..color = Colors.white.withAlpha(70)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.5,
          );
        }

        // Dot
        canvas.drawCircle(dotOffset, dotRadius, Paint()..color = Colors.white);

        if (isCurrent) {
          // Outline
          canvas.drawCircle(
            dotOffset,
            dotRadius,
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.2,
          );

          // Hiển thị ngày
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
    final tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    canvas.save();
    canvas.translate(offset.dx - tp.width / 2, offset.dy - tp.height / 2);
    tp.paint(canvas, Offset.zero);
    canvas.restore();
  }

  List<Color> _buildFullGradientColors(List<PhaseModel> phases) {
    final colors = <Color>[];
    for (int i = 0; i < phases.length; i++) {
      final c1 = phases[i].color.withAlpha(210);
      final c2 = i + 1 < phases.length
          ? phases[i + 1].color.withAlpha(160)
          : phases.first.color.withAlpha(160);
      colors.addAll([c1, Color.lerp(c1, c2, 0.5)!, c2]);
    }
    return colors;
  }

  List<double> _buildGradientStops(List<PhaseModel> phases) {
    final stops = <double>[];
    double current = 0;
    for (var phase in phases) {
      final sweepRatio = phase.days / totalDays;
      stops.add(current);
      stops.add(current + sweepRatio / 2);
      stops.add(current + sweepRatio);
      current += sweepRatio;
    }
    return stops;
  }

  @override
  bool shouldRepaint(covariant PrettyCyclePainter oldDelegate) =>
      oldDelegate.rotation != rotation ||
          oldDelegate.phases != phases ||
          oldDelegate.currentDay != currentDay;
}
