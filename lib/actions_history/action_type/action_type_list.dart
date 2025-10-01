import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_model.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_bloc.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_event.dart';
import 'package:women_diary/actions_history/action_type/bloc/action_type_state.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ActionTypeListScreen extends StatelessWidget {
  const ActionTypeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ActionTypeBloc()..add(LoadActionTypeEvent()),
      child: const _ActionTypeList(),
    );
  }
}

class _ActionTypeList extends StatefulWidget {
  const _ActionTypeList({Key? key}) : super(key: key);

  @override
  State<_ActionTypeList> createState() => _ActionTypeListState();
}

class _ActionTypeListState extends State<_ActionTypeList> {
  final _titleController = TextEditingController();
  final _emojiController = TextEditingController();

  void _openBottomSheet(BuildContext context, {ActionTypeModel? item}) {
    // giữ nguyên behavior ban đầu (prefill nếu edit)
    if (item != null) {
      _titleController.text = item.title;
      _emojiController.text = item.emoji;
    } else {
      _titleController.clear();
      _emojiController.clear();
    }

    final bloc = context.read<ActionTypeBloc>();
    bloc.add(UpdateActionTypeEvent(_emojiController.text, _titleController.text));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (dialogContext) {
        // đảm bảo bottom sheet dùng cùng instance bloc
        return BlocProvider.value(
          value: bloc,
          child: BlocBuilder<ActionTypeBloc, ActionTypeState>(
            builder: (context, state) {
              final bool isValid = (state is SaveButtonState)
                  ? state.isEnable
                  : (_titleController.text.trim().isNotEmpty &&
                  _emojiController.text.trim().isNotEmpty);

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: MediaQuery.of(dialogContext).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item == null ? "Thêm Action Type" : "Cập nhật Action Type")
                        .text18()
                        .w600()
                        .black87Color(),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emojiController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 28),
                      maxLength: 4,
                      onChanged: (emoji) {
                        context.read<ActionTypeBloc>().add(UpdateActionTypeEvent(emoji, _titleController.text));
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            r'[\u{1F300}-\u{1F64F}\u{1F680}-\u{1F6FF}\u{1F900}-\u{1F9FF}]',
                            unicode: true,
                          ),
                        ),
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "🌸",
                        filled: true,
                        fillColor: Colors.pink.shade50,
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _titleController,
                      onChanged: (title) {
                        context.read<ActionTypeBloc>().add(UpdateActionTypeEvent(_emojiController.text, title));
                      },
                      decoration: InputDecoration(
                        hintText: "Tên action type...",
                        filled: true,
                        fillColor: Colors.pink.shade50,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: isValid
                          ? () {
                        final title = _titleController.text.trim();
                        final emoji = _emojiController.text.trim();
                        // giữ nguyên logic tạo/update như file gốc
                        if (title.isNotEmpty && emoji.isNotEmpty) {
                          if (item == null) {
                            context
                                .read<ActionTypeBloc>()
                                .add(CreateActionTypeDetailEvent(title, emoji));
                          } else {
                            context.read<ActionTypeBloc>().add(
                              UpdateActionTypeDetailEvent(
                                id: item.id,
                                title: title,
                                emoji: emoji,
                              ),
                            );
                          }
                          Navigator.pop(dialogContext);
                        }
                      }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isValid ? AppColors.pinkTextColor : Colors.grey.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                      child: const Text("Lưu").text16().whiteColor().w500(),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9FB),
      appBar: BaseAppBar(
        hasBack: true,
        title: 'Danh sách Action Type',
        backgroundColor: AppColors.pinkTextColor,
      ),
      body: BlocBuilder<ActionTypeBloc, ActionTypeState>(
        buildWhen: (pre, cur) => cur is ActionTypeLoadedState,
        builder: (context, state) {
          List<ActionTypeModel> actionTypes =
          state is ActionTypeLoadedState ? state.actionTypes : [];
          if (actionTypes.isEmpty) {
            return Center(
              child: Text('Chưa có action type nào.').text16().black87Color(),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: actionTypes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final item = actionTypes[index];
              return Dismissible(
                key: ValueKey(item.id),
                background: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pinkTextColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                secondaryBackground: Container(
                  decoration: BoxDecoration(
                    color: AppColors.pinkTextColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context
                      .read<ActionTypeBloc>()
                      .add(DeleteActionTypeEvent(item.id));
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => _openBottomSheet(context, item: item),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade100.withAlpha(80),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 18,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFEEF2),
                          shape: BoxShape.circle,
                        ),
                        child: Text(item.emoji).text30(),
                      ),
                      title:
                      Text(item.title).w500().text17().black87Color(),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openBottomSheet(context),
        backgroundColor: AppColors.pinkTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
