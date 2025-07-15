import 'package:baby_diary/baby_index/index_model.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/date_time_extension.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class BabyWeightRow extends StatelessWidget {
  const BabyWeightRow({super.key, required this.babyWeight});
  final IndexModel babyWeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.only(left: 16,right: 16, top: 8, bottom: 8),
        decoration: BoxDecoration(
            color: Colors.white.withAlpha(150),
            borderRadius: const BorderRadius.all(Radius.circular(8))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: AppColors.mainColor, width: 1),
                      borderRadius: const BorderRadius.all(Radius.circular(6))
                  ),
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(babyWeight.value).w500().text20().blackColor().ellipsis().center(),
                      const SizedBox(height: 4),
                      const Text('gram').w400().text14().blackColor().ellipsis().center()
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(babyWeight.time.globalDateFormat())
                      .w500()
                      .text16()
                      .primaryTextColor()
                      .ellipsis()
                      .left(),

                )
              ],
            )
          ],
        )
    );
  }
}
