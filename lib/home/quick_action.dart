import 'package:flutter/material.dart';
import 'package:women_diary/home/app_card.dart';

class QuickAction extends StatelessWidget {
  final String title;
  final String emoji;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final BorderSide border;

  QuickAction({
    required this.title,
    required this.emoji,
    required this.background,
    required this.foreground,
    required this.border,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AppCard(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.fromBorderSide(border),
        shadows: [
          BoxShadow(
            color: Colors.pink.shade200.withAlpha(60),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}