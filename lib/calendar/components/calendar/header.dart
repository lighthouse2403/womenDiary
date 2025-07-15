import 'package:flutter/material.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class Header extends StatelessWidget {
  const Header({super.key, required this.currentMonth, required this.onPreviousPress, required this.onNextPress});
  final DateTime currentMonth;
  final Function onPreviousPress;
  final Function onNextPress;

  @override
  Widget build(BuildContext context) {
    var month = currentMonth.month;
    var year = currentMonth.year;
    var title = '${Constants.months[month - 1]} $year'.toUpperCase();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_left),
          iconSize: 30,
          color: Colors.black,
          onPressed: () {
            onPreviousPress();
          },
        ),
        Text(title).w700().text16().blackColor(),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          iconSize: 30,
          color: Colors.black,
          onPressed: () {
            onNextPress();
          },
        ),
      ],
    );
  }
}