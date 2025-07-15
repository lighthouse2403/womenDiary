import 'package:baby_diary/chat/model/thread_model.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/date_time_extension.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class ThreadRow extends StatefulWidget {
  const ThreadRow({super.key, required this.thread});

  final ThreadModel thread;

  @override
  State<ThreadRow> createState() => ThreadRowState();
}

class ThreadRowState extends State<ThreadRow> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.thread.deviceName ?? 'No name').w700().text15().mainColor().ellipsis(),
          const SizedBox(height: 6),
          Text(widget.thread.title).w400().text15(),
          const SizedBox(height: 10),
          Row(
            children: [
              Assets.icons.comments.svg(width: 16, height: 16),
              Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    alignment: Alignment.centerLeft,
                    child: Text('${widget.thread.commentsCount ?? 0}')
                        .w400()
                        .text13()
                        .customColor(AppColors.disableColor),
                  )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(widget.thread.createTime.toDate().generateDurationTime())
                    .w400()
                    .text13()
                    .customColor(AppColors.disableColor)
                    .right(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
