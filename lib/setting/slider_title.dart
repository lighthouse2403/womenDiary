import 'package:flutter/cupertino.dart';

class SliderTile extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final Function(int) onChanged;

  const SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: CupertinoSlider(
                  value: value.toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  divisions: max - min,
                  onChanged: (v) => onChanged(v.round()),
                ),
              ),
              const SizedBox(width: 10),
              Text("$value ngày",
                  style: const TextStyle(color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }
}
