import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/widgets/customTextField.dart';
import 'package:flutter/material.dart';

class InputRow extends StatefulWidget {
  const InputRow({
    super.key,
    this.title = '',
    this.hintText = '',
    this.onTextChanged,
    this.initValue = '',
    this.enable = true,
    this.keyboardType = TextInputType.text
  });

  final ValueChanged<String>? onTextChanged;
  final String hintText;
  final String title;
  final String initValue;
  final bool enable;
  final TextInputType keyboardType;

  @override
  State<InputRow> createState() => _InputRowState();
}

class _InputRowState extends State<InputRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initValue);
  }

  @override
  void didUpdateWidget(covariant InputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Chỉ update text nếu initValue thay đổi
    if (widget.initValue != oldWidget.initValue) {
      _controller.text = widget.initValue;
    }
  }

  @override
  void dispose() {
    debugPrint('dispose InputRow: ${widget.title}');
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title)
              .w500()
              .text14()
              .mainColor(),
          Constants.vSpacer6,
          CustomTextField(
            keyboard: widget.keyboardType,
            enable: widget.enable,
            controller: _controller,
            hintText: widget.hintText,
            onTextChanged: widget.onTextChanged,
            autofocus: false, // đảm bảo không bị auto-focus
          ),
        ],
      ),
    );
  }
}
