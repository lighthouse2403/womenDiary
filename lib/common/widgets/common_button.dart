import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/font_size_extension.dart';
import 'package:baby_diary/common/extension/font_weight_extension.dart';
import 'package:baby_diary/common/extension/text_color_extension.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  const CommonButton({
    Key? key,
    this.buttonText,
    this.textStyle,
    this.contentPadding,
    this.backgroundColor,
    this.onClick,
    this.borderRadius,
    this.customChild,
    this.enabled = true,
    this.disableBackgroundColor,
  }) : super(key: key);

  final String? buttonText;
  final TextStyle? textStyle;
  final EdgeInsets? contentPadding;
  final Color? backgroundColor;
  final Color? disableBackgroundColor;
  final double? borderRadius;
  final VoidCallback? onClick;
  final Widget? customChild;
  final bool? enabled;

  @override
  Widget build(BuildContext context) {
    final enableBg = backgroundColor ?? AppColors.mainColor;
    final disableBg = disableBackgroundColor ?? AppColors.disableColor;
    final buttonStyle = ButtonStyle(
      padding: WidgetStateProperty.all<EdgeInsets>(
        contentPadding ??
            const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      ),
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
        ),
      ),
      minimumSize: WidgetStateProperty.all(const Size(0.0, 0.0)),
      elevation: WidgetStateProperty.all(0),
      backgroundColor: WidgetStateProperty.all<Color>(
          enabled == true ? enableBg : disableBg),
      overlayColor: WidgetStateProperty.all<Color>(Colors.black.withAlpha(20)),
    );
    return ElevatedButton(
      style: buttonStyle,
      onPressed: enabled == true ? onClick : null,
      child: (customChild != null)
          ? customChild
          : Text(buttonText ?? '', style: textStyle ?? const TextStyle().textW400().text14().mainColor()),
    );
  }
}
