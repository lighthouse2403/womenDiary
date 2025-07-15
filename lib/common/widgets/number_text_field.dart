import 'package:women_diary/common/widgets/customTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumericTextField extends StatefulWidget {
  NumericTextField({super.key, this.onTextChanged, this.initialvalue});
  String? initialvalue;
  final ValueChanged<String>? onTextChanged;

  @override
  State<NumericTextField> createState() => _NumericTextFieldState();
}

class _NumericTextFieldState extends State<NumericTextField> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.initialvalue ?? '';

    return CustomTextField(
      hintText: 'Cân nặng',
      controller: _controller,
      maxLength: 4,
      keyboard: TextInputType.number,
      parameters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      enable: true,
      onTextChanged: widget.onTextChanged,
    );
  }

  @override
  void initState() {
    super.initState();
    _disablePaste();
  }

  void _disablePaste() {
    _controller.addListener(() {
      Clipboard.getData(Clipboard.kTextPlain).then((value) {
        if (value != null && value.text != null) {
          _controller.text = _controller.text.replaceAll(value.text!, '');
        }
      });
    });
  }
}