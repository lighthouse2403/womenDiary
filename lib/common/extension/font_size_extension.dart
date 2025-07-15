import 'package:flutter/cupertino.dart';

extension FontSizeExtension on TextStyle? {
  TextStyle text8() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 8,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text10() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 10,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text12() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 12,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text13() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 13,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text14() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 14,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text15() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 15,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text16() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 16,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text17() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 17,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text18() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 18,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text20() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 20,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle text30() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 30,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }

  TextStyle customSize(double size) {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: size,
      color:  this?.color,
      overflow: this?.overflow,
    );
  }
  /// Setup overflow
  TextStyle textEllipsis() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: TextOverflow.ellipsis,
    );
  }

  TextStyle textClip() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: TextOverflow.clip,
    );
  }

  TextStyle customHeight(double height) {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: this?.overflow,
      height: height
    );
  }
}