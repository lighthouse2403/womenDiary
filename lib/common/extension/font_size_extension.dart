import 'package:flutter/cupertino.dart';

extension FontSizeExtension on TextStyle? {
  TextStyle text8() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 8,
      color:  this?.color,
      overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle text10() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 10,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text12() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 12,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text13() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 13,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text14() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 14,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text15() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 15,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text16() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 16,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text17() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 17,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text18() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 18,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text20() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 20,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text22() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: 22,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle text24() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 24,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text26() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: 26,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle text28() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: 28,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle text30() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: 30,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle text36() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: 36,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: this?.fontStyle
    );
  }

  TextStyle customSize(double size) {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: size,
      color:  this?.color,
      overflow: this?.overflow,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }
  /// Setup overflow
  TextStyle textEllipsis() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: TextOverflow.ellipsis,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle textClip() {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: TextOverflow.clip,
      height: this?.height,
      fontStyle: this?.fontStyle
    );
  }

  TextStyle customHeight(double height) {
    return TextStyle(
      fontWeight: this?.fontWeight,
      fontSize: this?.fontSize,
      color:  this?.color,
      overflow: this?.overflow,
      height: height,
      fontStyle: this?.fontStyle
    );
  }
}