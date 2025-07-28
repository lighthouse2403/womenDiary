import 'package:flutter/material.dart';
import 'package:women_diary/actions_diary/bloc/action_bloc.dart';

class FilterSheet extends StatefulWidget {
  final DateTimeRange? initialRange;
  final List<HistoryActionType> initialTypes;

  const FilterSheet({this.initialRange, required this.initialTypes});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late DateTimeRange? _range;
  late List<HistoryActionType> _types;

  @override
  void initState() {
    super.initState();
    _range = widget.initialRange;
    _types = List.from(widget.initialTypes);
  }

  void _apply() {
    Navigator.pop(context, {
      'range': _range,
      'types': _types,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Bộ lọc lịch sử", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              children: HistoryActionType.values.map((type) {
                final selected = _types.contains(type);
                return FilterChip(
                  label: Text(type.name),
                  selected: selected,
                  onSelected: (val) {
                    setState(() {
                      if (val) {
                        _types.add(type);
                      } else {
                        _types.remove(type);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: now.subtract(const Duration(days: 365)),
                  lastDate: now,
                  initialDateRange: _range,
                );
                if (picked != null) {
                  setState(() => _range = picked);
                }
              },
              child: const Text("Chọn khoảng ngày"),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.done),
              label: const Text("Áp dụng"),
              onPressed: _apply,
            )
          ],
        ),
      ),
    );
  }
}
