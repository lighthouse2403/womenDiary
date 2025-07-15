import 'package:women_diary/chat/model/comment_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class ChatRow extends StatefulWidget {
  const ChatRow({super.key, required this.comment});

  final CommentModel comment;

  @override
  State<ChatRow> createState() => ChatRowState();
}

class ChatRowState extends State<ChatRow> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.comment.deviceName ?? 'No name').w500().text14().mainColor().ellipsis(),
          const SizedBox(height: 6),
          Text(widget.comment.content).w400().text16(),
          const SizedBox(height: 4),
          Row(
            children: [

              Align(
                alignment: Alignment.centerRight,
                child: Text(widget.comment.createTime.toDate().generateDurationTime())
                    .w400()
                    .text13()
                    .customColor(AppColors.disableColor)
                    .right(),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: Colors.grey.withOpacity(0.6))
        ],
      ),
    );
  }
}
