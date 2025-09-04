import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxBorder? border;
  final List<BoxShadow>? shadows;

  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.border,
    this.shadows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        border: border,
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.pink.shade100.withAlpha(750),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
      ),
      child: child,
    );
  }
}