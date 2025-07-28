import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_diary/action_history.dart';

class ActionDetail extends StatefulWidget {
  final UserAction action;

  const ActionDetail({super.key, required this.action});

  @override
  State<ActionDetail> createState() => _ActionDetailState();
}

class _ActionDetailState extends State<ActionDetail> {
  late TextEditingController titleController;
  late TextEditingController noteController;
  late DateTime selectedDateTime;
  late String selectedEmoji;

  final List<String> emojis = ['💊', '🩸', '💧', '😣', '🥴', '😌'];

  @override
  void initState() {
    super.initState();
    selectedEmoji = widget.action.emoji;
    titleController = TextEditingController(text: widget.action.title);
    noteController = TextEditingController(text: widget.action.note);
    selectedDateTime = widget.action.time;
  }

  @override
  Widget build(BuildContext context) {
    final dateText = DateFormat("dd/MM/yyyy – HH:mm").format(selectedDateTime);

    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.extraLightBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        middle: const Text("📝 Chi tiết hành động"),
        trailing: GestureDetector(
          onTap: _onDelete,
          child: const Icon(
            CupertinoIcons.delete_simple,
            color: CupertinoColors.systemRed,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("Biểu tượng"),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: emojis.map((emoji) {
                    final isSelected = selectedEmoji == emoji;
                    return GestureDetector(
                      onTap: () => setState(() => selectedEmoji = emoji),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? CupertinoColors.systemPink.withOpacity(0.15)
                              : CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? CupertinoColors.systemPink
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 26),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 28),
                _buildSectionTitle("Tiêu đề"),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: titleController,
                  placeholder: "Nhập tiêu đề...",
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Ghi chú"),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: noteController,
                  placeholder: "Ghi chú chi tiết...",
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  maxLines: null,
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle("Thời gian"),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(CupertinoIcons.time, size: 20, color: CupertinoColors.systemGrey),
                        const SizedBox(width: 8),
                        Text(dateText, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Center(
                  child: CupertinoButton.filled(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    borderRadius: BorderRadius.circular(30),
                    onPressed: _onSave,
                    child: const Text("💾 Lưu lại", style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: CupertinoColors.systemPink,
      ),
    );
  }

  void _pickDateTime() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemGroupedBackground,
        child: CupertinoDatePicker(
          initialDateTime: selectedDateTime,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (value) => setState(() => selectedDateTime = value),
          mode: CupertinoDatePickerMode.dateAndTime,
        ),
      ),
    );
  }

  void _onSave() {
    final updatedAction = UserAction(
      selectedEmoji,
      titleController.text,
      noteController.text,
      selectedDateTime,
    );
    Navigator.of(context).pop(updatedAction);
  }

  void _onDelete() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text("Xoá bản ghi"),
        message: const Text("Bạn có chắc muốn xoá hành động này không?"),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(context).pop(); // close sheet
              Navigator.of(context).pop(null); // return null
            },
            child: const Text("Xoá"),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Huỷ"),
        ),
      ),
    );
  }
}
