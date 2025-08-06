import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/actions_history/user_action_model.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ActionDetail extends StatefulWidget {
  final UserAction action;

  const ActionDetail({super.key, required this.action});

  @override
  State<ActionDetail> createState() => _ActionDetailState();
}

class _ActionDetailState extends State<ActionDetail>
    with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime _selectedDate;
  late String _selectedEmoji;

  bool _showDatePicker = false;
  late AnimationController _emojiController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.action.title);
    _noteController = TextEditingController(text: widget.action.note);
    _selectedDate = widget.action.time;
    _selectedEmoji = widget.action.emoji;

    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 1.0,
      upperBound: 1.2,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _emojiController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _toggleDatePicker() {
    setState(() => _showDatePicker = !_showDatePicker);
  }

  void _onSelectEmoji(String emoji) {
    setState(() => _selectedEmoji = emoji);
    _emojiController.forward(from: 1.0);
  }

  void _save() => Navigator.pop(context);
  void _delete() => Navigator.pop(context);

  Widget _buildBlurredDatePicker() {
    if (!_showDatePicker) return const SizedBox();
    return Stack(
      children: [
        GestureDetector(
          onTap: _toggleDatePicker,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(color: Colors.black.withAlpha(50)),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              initialDateTime: _selectedDate,
              onDateTimeChanged: (date) {
                setState(() => _selectedDate = date);
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final emojis = ["💊", "🩸", "💧", "😴", "😣"];
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: BaseAppBar(
        title: "✏️ Chi tiết hành động",
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 30 + bottomInset),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Chọn biểu tượng")
                        .w600()
                        .text16()
                        .customColor(CupertinoColors.systemPink),
                    const SizedBox(height: 10),
                    Row(
                      children: emojis.map((e) {
                        final isSelected = _selectedEmoji == e;
                        return GestureDetector(
                          onTap: () => _onSelectEmoji(e),
                          child: ScaleTransition(
                            scale: isSelected
                                ? _emojiController
                                : AlwaysStoppedAnimation(1.0),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 6),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? CupertinoColors.systemPink.withOpacity(0.2)
                                    : CupertinoColors.secondarySystemBackground,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  fontSize: 28,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text("Tiêu đề")
                        .w600()
                        .text16()
                        .customColor(CupertinoColors.label),
                    const SizedBox(height: 6),
                    CupertinoTextField(
                      controller: _titleController,
                      placeholder: "Nhập tiêu đề...",
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Ghi chú")
                        .w600()
                        .text16()
                        .customColor(CupertinoColors.label),
                    const SizedBox(height: 6),
                    CupertinoTextField(
                      controller: _noteController,
                      placeholder: "Nhập ghi chú...",
                      maxLines: 3,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Thời gian")
                        .w600()
                        .text16()
                        .customColor(CupertinoColors.label),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      color: CupertinoColors.systemPink.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      onPressed: _toggleDatePicker,
                      child: Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} - ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: CupertinoColors.systemPink,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: CupertinoButton(
                            color: CupertinoColors.systemGrey,
                            borderRadius: BorderRadius.circular(30),
                            child: const Text("Xoá"),
                            onPressed: _delete,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CupertinoButton.filled(
                            borderRadius: BorderRadius.circular(30),
                            child: const Text("Lưu"),
                            onPressed: _save,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          _buildBlurredDatePicker(),
        ],
      ),
    );
  }
}
