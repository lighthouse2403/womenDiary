import 'package:flutter/material.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key, required this.title, required this.content});
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.calendar.svg(
              width: 80,
              height: 80,
              colorFilter: ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn)
          ),
          Constants.vSpacer16,
          Text(title).text16().w500().customColor(Colors.grey.shade600),
          Constants.vSpacer16,
          Text(content).text14().w400().customColor(Colors.grey.shade500).center(),
        ],
      ),
    );
  }
}
