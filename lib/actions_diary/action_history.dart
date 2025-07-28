import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/actions_diary/new_action.dart';
import 'package:women_diary/actions_diary/user_action_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class ActionHistory extends StatelessWidget {
  const ActionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final groupedData = _mockGroupedActions();

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("📖 Lịch sử hành động"),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: groupedData.length,
              itemBuilder: (context, index) {
                final date = groupedData.keys.elementAt(index);
                final actions = groupedData[date]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 8),
                      child: Text(
                        date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemPink,
                        ),
                      ),
                    ),
                    ...actions.map((action) {
                      return GestureDetector(
                        onTap: () {
                          context.navigateTo(RoutesName.actionDetail, arguments: action);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                action.emoji,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      action.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (action.note.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          action.note,
                                          style: const TextStyle(
                                            color: CupertinoColors.systemGrey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('HH:mm').format(action.time),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemGrey2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList()
                  ],
                );
              },
            ),
            Positioned(
              bottom: 24,
              right: 24,
              child: CupertinoButton.filled(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                borderRadius: BorderRadius.circular(30),
                onPressed: () {
                  Navigator.of(context).push(CupertinoPageRoute(
                    builder: (_) => const NewAction(),
                  ));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CupertinoIcons.add, size: 20, color: CupertinoColors.white),
                    SizedBox(width: 6),
                    Text(
                      "Thêm bản ghi",
                      style: TextStyle(color: CupertinoColors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, List<UserAction>> _mockGroupedActions() {
    final now = DateTime.now();
    return {
      "Hôm nay": [
        UserAction("💊", "Uống thuốc", "Viên tránh thai", now.subtract(const Duration(hours: 1))),
        UserAction("🩸", "Đau bụng", "Cảm giác nhói", now.subtract(const Duration(hours: 3))),
      ],
      "Hôm qua": [
        UserAction("💧", "Ra dịch", "Không mùi", now.subtract(const Duration(days: 1, hours: 2))),
      ]
    };
  }
}
