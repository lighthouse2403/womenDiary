import 'package:flutter/material.dart';
import 'package:baby_diary/common/constants/app_colors.dart';

class LoadingView {

  late OverlayEntry _progressOverlayEntry;

  void show(BuildContext context){
    _progressOverlayEntry = _createdProgressEntry(context);
    Overlay.of(context).insert(_progressOverlayEntry);
  }

  void hide() {
    _progressOverlayEntry.remove();
  }

  OverlayEntry _createdProgressEntry(BuildContext context) =>
      OverlayEntry(
          builder: (BuildContext context) =>
              Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  Positioned(
                    top: screenHeight(context) / 2,
                    left: screenWidth(context) / 2,
                    child: CircularProgressIndicator(color: AppColors.mainColor),
                  )

                ],

              )
      );

  double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

}