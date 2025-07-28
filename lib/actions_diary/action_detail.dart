import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_diary/action_history.dart';

class ActionDetail extends StatefulWidget {
  final UserAction action;

  const ActionDetail({super.key, required this.action});

  @override
  State<ActionDetail> createState() => _ActionDetailState();
}

class _ActionDetailState extends State<ActionDetail> {
  late TextEditingController _titleController;
  late TextEditingController _noteController;
  late DateTime _selectedDateTime;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.action.title);
    _noteController = TextEditingController(text: widget.action.note);
    _selectedDateTime = widget.action.time;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() => _isEditing = !_isEditing);
  }

  void _saveChanges() {
    setState(() {
      _isEditing = false;
    });

    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Đã lưu"),
        content: const Text("Hành động đã được cập nhật."),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  void _pickDateTime() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: _selectedDateTime,
          onDateTimeChanged: (dt) => setState(() => _selectedDateTime = dt),
        ),
      ),
    );
  }

  void _confirmDelete() {
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text("Xoá hành động"),
        content: const Text("Bạn có chắc muốn xoá bản ghi này?"),
        actions: [
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text("Xoá"),
            onPressed: () {
              // TODO: Handle delete
              Navigator.of(context)
                ..pop()
                ..pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text("Huỷ"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text("Chi tiết hành động"),
        trailing: _isEditing
            ? CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Text("Lưu"),
          onPressed: _saveChanges,
        )
            : CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.pencil, size: 22),
          onPressed: _toggleEdit,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.action.emoji,
                style: const TextStyle(fontSize: 64),
              ),
              const SizedBox(height: 16),
              _buildInputCard(context),
              const Spacer(),
              CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                borderRadius: BorderRadius.circular(30),
                child: const Text("🗑️ Xoá hành động"),
                onPressed: _confirmDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _isEditing
              ? CupertinoTextField(
            controller: _titleController,
            placeholder: "Tiêu đề",
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          )
              : _infoRow("📝 Tiêu đề", _titleController.text),
          const SizedBox(height: 12),
          _isEditing
              ? CupertinoTextField(
            controller: _noteController,
            placeholder: "Ghi chú",
            maxLines: 3,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          )
              : _infoRow("📌 Ghi chú", _noteController.text),
          const SizedBox(height: 12),
          _isEditing
              ? GestureDetector(
            onTap: _pickDateTime,
            child: _infoRow("📅 Ngày", DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDateTime)),
          )
              : _infoRow("📅 Ngày", DateFormat('dd MMMM yyyy, HH:mm').format(_selectedDateTime)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: CupertinoColors.systemPink,
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: CupertinoColors.label,
            ),
          ),
        ),
      ],
    );
  }
}
