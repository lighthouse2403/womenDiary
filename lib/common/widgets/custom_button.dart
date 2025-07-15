import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/base/base_child_stateful_widget.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class CustomButton extends BaseChildStatefulWidget {
  CustomButton({super.key, this.backgroundColor, required this.onTappedAction, required this.title, this.titleColor, this.titleAlignment, this.horizontalPadding, this.borderColor});

  double? horizontalPadding;
  String title;
  Color? backgroundColor;
  Color? borderColor;
  Color? titleColor;
  AlignmentGeometry? titleAlignment;
  VoidCallback onTappedAction;

  @override
  State<CustomButton> createState() => _DiaryState();
}

class _DiaryState extends BaseChildStatefulState<CustomButton> {

  @override
  Widget? buildBody() {
    return InkWell(
      onTap: widget.onTappedAction,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding ?? 20),
        alignment: widget.titleAlignment ?? Alignment.center,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            color: widget.backgroundColor,
            border: Border.all(width: 1, color: widget.borderColor ?? Colors.transparent)
        ),
        child: Text(
          widget.title,
        ).w600().text16().customColor(widget.titleColor).left(),
      ),
    );
  }
}