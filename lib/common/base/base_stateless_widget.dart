import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class BaseStatelessWidget extends StatelessWidget {
  BaseStatelessWidget({super.key});

  late double screenWidth;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return buildBody(context) ?? Container();
  }

  Widget? buildBody(BuildContext context) {
    return null;
  }

  void showCupertinoAlert(
      String? title,
      String? content,
      String actionText,
      BuildContext context,
      VoidCallback action) {

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title ?? ''),
          content: Text(content ?? ''),
          actions: [
            CupertinoDialogAction(
                child: Text('Huỷ').w600().text14().greyColor(),
                onPressed: (){
                  Navigator.of(context).pop();
                }
            ),
            CupertinoDialogAction(
                child: Text(actionText).w600().text14().greyColor(),
                onPressed: () {
                  action();
                  Navigator.of(context).pop();
                }
            )
          ],
        );
      },
    );
  }
}

