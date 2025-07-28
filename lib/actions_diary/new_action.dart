import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewAction extends StatefulWidget {
  const NewAction({super.key});

  @override
  State<NewAction> createState() => _NewActionState();
}

class _NewActionState extends State<NewAction> {
  DateTime selectedDate = DateTime.now();
  String? selectedType;
  final noteController = TextEditingController();

  final List<String> actionTypes = [
    "💊 Uống thuốc",
    "🤕 Đau bụng",
    "😴 Mệt mỏi",
    "🍫 Thèm đồ ngọt",
    "🥵 Nóng trong",
  ];

  void _saveAction() {
    if (selectedType == null) return;

    // TODO: Dispatch to Bloc or save to storage
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text("Hành động mới")),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text("Ngày", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 12),
              onPressed: () => _pickDate(),
              child: Text(DateFormat('dd/MM/yyyy').format(selectedDate)),
            ),
            const SizedBox(height: 20),
            const Text("Loại hành động", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: actionTypes.map((type) {
                final isSelected = selectedType == type;
                return ChoiceChip(
                  label: Text(type),
                  selected: isSelected,
                  onSelected: (_) => setState(() => selectedType = isSelected ? null : type),
                  selectedColor: CupertinoColors.systemPink.withAlpha(80),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Ghi chú", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
            )
          ],
        ),
      ),
    );
  }

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
