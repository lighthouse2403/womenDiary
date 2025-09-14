import 'package:women_diary/chat/model/thread_model.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ThreadRow extends StatelessWidget {
  const ThreadRow({super.key, required this.thread});

  final ThreadModel thread;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD), // nền trắng ngà dịu mắt
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Device name
          Text(thread.deviceName ?? 'No name')
              .w600()
              .text15()
              .customColor(AppColors.mainColor),
          const SizedBox(height: 8),

          /// Title / nội dung thread
          Text(thread.content)
              .w400()
              .text14()
              .customColor(const Color(0xFF444444)),
          const SizedBox(height: 12),

          /// Footer row: comments & time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Assets.icons.comments.svg(
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.mainColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text('${thread.commentsCount ?? 0}')
                      .w400()
                      .text13()
                      .customColor(const Color(0xFF7A7A7A)),
                ],
              ),
              Text(thread.createTime.toDate().generateDurationTime())
                  .w400()
                  .text13()
                  .customColor(const Color(0xFF9E9E9E)),
            ],
          ),
        ],
      ),
    );
  }
}
