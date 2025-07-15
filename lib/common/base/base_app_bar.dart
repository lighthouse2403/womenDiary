import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  String? title;
  List<Widget>? actions = [];
  bool? hasBack = false;

  BaseAppBar({required this.title, this.actions, this.hasBack, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title ?? '').w600().text18().mainColor().ellipsis(),
      backgroundColor: Colors.white,
      actions: actions,
      leading: hasBack == true ? InkWell(
        onTap: () => context.pop(),
        child: Align(
          alignment: Alignment.center,
          child: Assets.icons.arrowBack.svg(
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(AppColors.primaryTextColor, BlendMode.srcIn)
          ),
        ),
      ) : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}