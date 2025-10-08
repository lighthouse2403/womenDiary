import 'package:flutter/cupertino.dart';

extension FontSizeExtension on TextStyle? {
  TextStyle italicStyle() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: FontStyle.italic
    );
  }

  TextStyle normalStyle() {
    return TextStyle(
        fontWeight: this?.fontWeight,
        fontSize: this?.fontSize,
        color:  this?.color,
        overflow: this?.overflow,
        height: this?.height,
        fontStyle: FontStyle.normal,
    );
  }
}