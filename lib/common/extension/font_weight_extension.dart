import 'package:flutter/cupertino.dart';

extension FontWeightExtension on TextStyle? {
  TextStyle textW400() {
    return TextStyle(
        fontWeight: FontWeight.w400,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow
    );
  }

  TextStyle textW500() {
    return TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow
    );
  }

  TextStyle textW600() {
    return TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow
    );
  }

  TextStyle textW700() {
    return TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: this?.fontSize,
        color: this?.color,
        overflow: this?.overflow
    );
  }

  TextStyle textW800() {
    return TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: this?.fontSize,
        color: this?.color,
        overflow: this?.overflow
    );
  }


  TextStyle customWeight(FontWeight? weight) {
    return TextStyle(
        fontWeight: weight,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height
    );
  }
}
