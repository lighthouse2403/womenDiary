import 'dart:io';
import 'package:women_diary/diary/diary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationRow extends StatelessWidget {
  const MenstruationRow({super.key, required this.menstruation});
  final MenstruationModel menstruation;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(70),
          borderRadius: const BorderRadius.all(Radius.circular(6))
      ),
      child: Row(
        children: [
          Text('Ngày bắt đầu: ${menstruation.startTime.globalDateFormat()}')
              .w400()
              .text12()
              .primaryTextColor()
              .ellipsis(),
          Text('Ngày Kết thúc: ${menstruation.endTime.globalDateFormat()}')
              .w400()
              .text12()
              .primaryTextColor()
              .ellipsis(),
          const SizedBox(width: 8),
          Expanded(
              child: Text(menstruation.note)
                  .w400()
                  .text12()
                  .primaryTextColor()
                  .ellipsis()
                  .right()
          )
        ],
      ),
    );
  }
}
