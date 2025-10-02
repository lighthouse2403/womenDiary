import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/constants/constants.dart';

extension FontWeightExtension on TextStyle? {
  TextStyle pinkTextColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.pinkTextColor(),
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle mainColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.mainColor(),
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle primaryTextColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Constants.primaryTextColor(),
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle blackColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.black,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle black87Color() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.black87,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle pink700Color() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.pink.shade700,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle pink300Color() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.pink.shade300,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle pink800Color() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.pink.shade800,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle whiteColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.white,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle redColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.red,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle greyColor() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  Colors.grey,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle customColor(Color? color) {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }
}
