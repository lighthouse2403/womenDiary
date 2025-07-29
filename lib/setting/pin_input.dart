import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinInputDialog extends StatefulWidget {
  const PinInputDialog({super.key});

  @override
  State<PinInputDialog> createState() => _PinInputDialogState();
}

class _PinInputDialogState extends State<PinInputDialog> {
  final List<String> _input = [];

  void _addDigit(String digit) {
    if (_input.length >= 6) return;
    setState(() => _input.add(digit));
    if (_input.length == 6) {
      final pin = _input.join();
      Navigator.of(context).pop(pin);
    }
  }

  void _removeDigit() {
    if (_input.isEmpty) return;
    setState(() => _input.removeLast());
  }

  Widget _buildPinDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
            (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: index < _input.length ? Colors.black : Colors.transparent,
            border: Border.all(color: Colors.black, width: 1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboardButton(String label, {VoidCallback? onTap}) {
    return Expanded(
      child: CupertinoButton(
        onPressed: onTap ?? () => _addDigit(label),
        padding: EdgeInsets.zero,
        child: Container(
          alignment: Alignment.center,
          height: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 28),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyboard() {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['←', '0', '⌫']
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: row.map((label) {
              if (label == '←' || label == '⌫') {
                return _buildKeyboardButton(label, onTap: _removeDigit);
              } else {
                return _buildKeyboardButton(label);
              }
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text("Nhập mã PIN"),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            _buildPinDots(),
            const SizedBox(height: 16),
            _buildKeyboard(),
          ],
        ),
      ),
      actions: [
        CupertinoDialogAction(
          child: const Text("Hủy"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
