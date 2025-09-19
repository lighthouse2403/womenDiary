import 'package:flutter/material.dart';
import 'package:women_diary/schedule/schedule_list/schedule_card.dart';
import 'package:women_diary/schedule/schedule_model.dart';

/// Card có animation fade + slide
class AnimatedScheduleCard extends StatefulWidget {
  final ScheduleModel schedule;
  final int index;

  const AnimatedScheduleCard({
    required this.schedule,
    required this.index,
  });

  @override
  State<AnimatedScheduleCard> createState() => _AnimatedScheduleCardState();
}

class _AnimatedScheduleCardState extends State<AnimatedScheduleCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 400 + widget.index * 80),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    Future.delayed(Duration(milliseconds: widget.index * 120), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _offsetAnimation,
        child: ScheduleCard(schedule: widget.schedule),
      ),
    );
  }
}