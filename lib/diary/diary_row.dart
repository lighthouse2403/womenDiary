import 'dart:io';
import 'package:women_diary/diary/diary_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class DiaryRow extends StatelessWidget {
  const DiaryRow({super.key, required this.diary});
  final DiaryModel diary;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white.withAlpha(100),
          borderRadius: const BorderRadius.all(Radius.circular(6))
      ),
      child: Row(
        children: [
          _buildImageRow(),
          const SizedBox(width: 8),
          Expanded(
              child: Text(diary.time.globalDateFormat()).w400().text12().primaryTextColor().ellipsis().right()
          )
        ],
      ),
    );
  }

  Widget _buildImageRow() {
    if (diary.url.isEmpty) {
      return Container();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Image border
      child: SizedBox.fromSize(
        size: const Size.fromRadius(60), // Image radius
        child: Image.file(
          File(diary.url.first),
          errorBuilder: (BuildContext context, Object error,
              StackTrace? stackTrace) {
            return const Center(
                child: Text('This image type is not supported'));
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}