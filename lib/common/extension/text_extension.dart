import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/common/extension/font_size_extension.dart';
import 'package:baby_diary/common/extension/font_weight_extension.dart';
import 'package:baby_diary/common/extension/text_color_extension.dart';


extension TextExtension on Text? {
  /// Setup color for text
  Text customColor(Color? color) {
    return Text(this?.data ?? '', style: this?.style?.customColor(color), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text primaryTextColor() {
    return Text(this?.data ?? '', style: this?.style?.primaryTextColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text pinkColor() {
    return Text(this?.data ?? '', style: this?.style?.pinkTextColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text greyColor() {
    return Text(this?.data ?? '', style: this?.style?.greyColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text whiteColor() {
    return Text(this?.data ?? '', style: this?.style?.whiteColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text redColor() {
    return Text(this?.data ?? '', style: this?.style?.redColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text blackColor() {
    return Text(this?.data ?? '', style: this?.style?.blackColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text mainColor() {
    return Text(this?.data ?? '', style: this?.style?.mainColor(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }
  /// Setup font weight for text
  Text w400() {
    return Text(this?.data ?? '', style: this?.style?.textW400(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text w500() {
    return Text(this?.data ?? '', style: this?.style.textW500(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text w600() {
    return Text(this?.data ?? '', style: this?.style.textW600(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text w700() {
    return Text(this?.data ?? '', style: this?.style.textW700(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text w800() {
    return Text(this?.data ?? '', style: this?.style.textW800(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text customWeight(FontWeight? weight) {
    return Text(this?.data ?? '', style: this?.style?.customWeight(weight), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  /// Setup font size for text

  Text text8() {
    return Text(this?.data ?? '', style: this?.style?.text8(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text10() {
    return Text(this?.data ?? '', style: this?.style.text10(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text12() {
    return Text(this?.data ?? '', style: this?.style.text12(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text13() {
    return Text(this?.data ?? '', style: this?.style.text13(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text14() {
    return Text(this?.data ?? '', style: this?.style.text14(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text15() {
    return Text(this?.data ?? '', style: this?.style.text15(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text16() {
    return Text(this?.data ?? '', style: this?.style.text16(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text17() {
    return Text(this?.data ?? '', style: this?.style.text17(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text18() {
    return Text(this?.data ?? '', style: this?.style.text18(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text20() {
    return Text(this?.data ?? '', style: this?.style.text20(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text text30() {
    return Text(this?.data ?? '', style: this?.style.text30(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text customSize(double size) {
    return Text(this?.data ?? '', style: this?.style?.customSize(size), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  /// Setup textEllipsis
  Text ellipsis() {
    return Text(this?.data ?? '', style: this?.style.textEllipsis(), textAlign: this?.textAlign, overflow: TextOverflow.ellipsis, maxLines: this?.maxLines);
  }

  Text clip() {
    return Text(this?.data ?? '', style: this?.style.textClip(), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text customHeight(double height) {
    return Text(this?.data ?? '', style: this?.style?.customHeight(height), textAlign: this?.textAlign, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  /// Setup allignment
  Text center() {
    return Text(this?.data ?? '', style: this?.style, textAlign: TextAlign.center, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text left() {
    return Text(this?.data ?? '', style: this?.style, textAlign: TextAlign.left, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text right() {
    return Text(this?.data ?? '', style: this?.style, textAlign: TextAlign.right, overflow: this?.overflow, maxLines: this?.maxLines);
  }

  Text numberOfLines(int maxLines) {
    return Text(this?.data ?? '', style: this?.style, textAlign: this?.textAlign, maxLines: maxLines, overflow: this?.overflow);
  }
}