import 'package:flutter/material.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class DayOfWeek extends StatelessWidget {
  const DayOfWeek(this.title, this.width, {super.key});

  final String title;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: Center(
        child: Text(title.toUpperCase()).w700().text16().center().blackColor(),
      ),
    );
  }
}
