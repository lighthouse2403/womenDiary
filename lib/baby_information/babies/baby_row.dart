import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/date_time_extension.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:blur/blur.dart';
import 'package:flutter/material.dart';


class BabyRow extends StatelessWidget {
  BabyRow(this.backgroundColor, this.borderColor, {super.key, required this.baby});

  BabyModel baby;
  Color backgroundColor = AppColors.secondaryTextColor;
  Color borderColor = Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
    ).blurred(
        blur: 3,
        blurColor: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        overlay: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              border: Border.all(
                  color: borderColor,
                  strokeAlign: BorderSide.strokeAlignCenter,
                  style: BorderStyle.solid,
                  width: 4
              )
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _babyInformationRow(0),
              const SizedBox(height: 12),
              _babyInformationRow(1),
              const SizedBox(height: 12),
              _babyInformationRow(2),
              const SizedBox(height: 12),
              _babyInformationRow(3),
              const SizedBox(height: 12),
              _babyInformationRow(4),
            ],
          ),
        )
    );
  }

  Widget _babyInformationRow(int index) {
    String title = '';
    String content = '-';
    DateTime? birthDate = baby.birthDate;
    String babyName = baby.babyName;

    switch (index) {
      case 1:
        title = 'Bé yêu:';
        content = babyName.isNotEmpty ? babyName : '-';
        break;
      case 2:
        title = 'Ngày sinh:';
        content = birthDate.globalDateFormat();
        break;
      default:
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title).w400().text14().primaryTextColor().ellipsis(),
        Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(content).w500().text14().primaryTextColor().ellipsis(),
            )
        ),
      ],
    );
  }
}