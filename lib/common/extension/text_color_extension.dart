import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/common/constants/constants.dart';

extension FontWeightExtension on TextStyle? {
  TextStyle pinkTextColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.pinkTextColor(),
        overflow: this?.overflow
    );
  }

  TextStyle mainColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.mainColor(),
        overflow: this?.overflow
    );
  }

  TextStyle primaryTextColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.primaryTextColor(),
        overflow: this?.overflow
    );
  }

  TextStyle blackColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.black,
        overflow: this?.overflow
    );
  }

  TextStyle whiteColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.white,
        overflow: this?.overflow
    );
  }

  TextStyle redColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.red,
        overflow: this?.overflow
    );
  }

  TextStyle greyColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.grey,
        overflow: this?.overflow
    );
  }

  TextStyle customColor(Color? color) {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  color,
        overflow: this?.overflow
    );
  }
}
