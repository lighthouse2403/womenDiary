import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ActionType {
  medicine,
  stomachache,
  tired,
  sweetCraving,
  hotInside,
}

extension ActionTypeExtension on ActionType {
  String get emoji {
    switch (this) {
      case ActionType.medicine:
        return '💊';
      case ActionType.stomachache:
        return '🤕';
      case ActionType.tired:
        return '😴';
      case ActionType.sweetCraving:
        return '🍫';
      case ActionType.hotInside:
        return '🥵';
    }
  }

  String get label {
    switch (this) {
      case ActionType.medicine:
        return 'Uống thuốc';
      case ActionType.stomachache:
        return 'Đau bụng';
      case ActionType.tired:
        return 'Mệt mỏi';
      case ActionType.sweetCraving:
        return 'Thèm đồ ngọt';
      case ActionType.hotInside:
        return 'Nóng trong';
    }
  }

  String get display => '$emoji $label';
}

class NewAction extends StatefulWidget {
  const NewAction({super.key});

  @override
  State<NewAction> createState() => _NewActionState();
}

class _NewActionState extends State<NewAction> {
  DateTime selectedDate = DateTime.now();
  ActionType? selectedType;
  final noteController = TextEditingController();

  void _saveAction() {
    if (selectedType == null) return;

    // TODO: Dispatch to Bloc or save to storage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Hành động mới"),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildSectionTitle("Ngày"),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPressed: _pickDate,
              child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Loại hành động"),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: ActionType.values.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type.display),
                  selected: isSelected,
                  onSelected: (_) =>
                      setState(() => selectedType = isSelected ? null : type),
                  selectedColor: CupertinoColors.systemPink.withAlpha(80),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildSectionTitle("Ghi chú"),
            const SizedBox(height: 6),
            CupertinoTextField(
              controller: noteController,
              placeholder: "Ghi chú thêm nếu có...",
              padding: const EdgeInsets.all(14),
            ),
            const SizedBox(height: 30),
            CupertinoButton.filled(
              child: const Text("Lưu"),
              onPressed: _saveAction,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  );

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 90)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }
}
