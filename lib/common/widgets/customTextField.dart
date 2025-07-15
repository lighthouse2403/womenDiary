import 'package:women_diary/common/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextInputType? keyboard;
  final List<TextInputFormatter>? parameters;
  final String? errorText;
  final String? hintText;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool enable;
  final bool autofocus;
  final ValueChanged<String>? onTextChanged;

  const CustomTextField({
    super.key,
    this.controller,
    this.keyboard,
    this.parameters,
    this.errorText,
    this.hintText,
    this.minLines = 1,
    this.maxLines,
    this.maxLength,
    this.onTextChanged,
    this.enable = true,
    this.autofocus = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double radius = 8;
    const double borderWidth = 1;

    final defaultBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        width: borderWidth,
        color: AppColors.secondaryTextColor.withAlpha(50),
      ),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius),
      borderSide: BorderSide(
        width: borderWidth,
        color: AppColors.mainColor,
      ),
    );

    const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(
        width: borderWidth,
        color: Colors.red,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          autofocus: widget.autofocus,
          keyboardType: widget.keyboard,
          inputFormatters: widget.parameters,
          enabled: widget.enable,
          controller: widget.controller,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          style: TextStyle(
            color: widget.enable ? AppColors.primaryTextColor : AppColors.disableColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            enabledBorder: defaultBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            disabledBorder: defaultBorder,
            focusedErrorBorder: errorBorder,
            fillColor: widget.enable
                ? Colors.white.withAlpha(150)
                : AppColors.disableColor.withAlpha(50),
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.disableColor,
            ),
            errorText: widget.errorText,
            errorStyle: const TextStyle(fontSize: 0),
            counter: const SizedBox.shrink(),
          ),
          onChanged: widget.onTextChanged,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
        ),
        if (widget.errorText?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
      ],
    );
  }
}
