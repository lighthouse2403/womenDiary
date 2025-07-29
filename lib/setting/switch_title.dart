import 'package:flutter/cupertino.dart';

class SwitchTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label,
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.label,
                )),
          ),
          CupertinoSwitch(
            value: value,
            onChanged: onChanged,
            inactiveTrackColor: CupertinoColors.systemPink,
          ),
        ],
      ),
    );
  }
}
