import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/context_extension.dart';
import 'package:women_diary/common/extension/font_size_extension.dart';
import 'package:women_diary/common/extension/font_weight_extension.dart';
import 'package:women_diary/common/extension/text_color_extension.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:flutter/material.dart';

class MainBottomTabBar extends StatefulWidget {
  const MainBottomTabBar({super.key, required this.child});

  final Widget child;

  @override
  State<MainBottomTabBar> createState() => MainBottomTabBarState();
}

class MainBottomTabBarState extends State<MainBottomTabBar> {
  int selectedIndex = 0;

  List<String> routeNames = [RoutesName.home, RoutesName.cycleList, RoutesName.schedules, RoutesName.actionHistory];
  late List<String> labels;
  List<SvgGenImage> images = [Assets.icons.home, Assets.icons.history, Assets.icons.calendar, Assets.icons.actions];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.language;
    labels = ['Trang chủ','Lịch sử', 'Kế hoạch', 'Hoạt động'];
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: labels.map((e) => _generateItem(labels.indexOf(e))).toList(),
        currentIndex: selectedIndex,
        unselectedLabelStyle: const TextStyle().greyColor().text12().textW600(),
        selectedLabelStyle: const TextStyle().mainColor().text12().textW600(),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        selectedItemColor: AppColors.mainColor,
        unselectedItemColor: AppColors.disableColor,
        onTap: _onTap,
      ),
    );
  }
  /// Generate item colors
  Color _generateItemColor(int index) {
    Color itemColor = selectedIndex == index ? AppColors.mainColor : AppColors.disableColor;
    return itemColor;
  }

  /// Generate item text style
  TextStyle _generateTextStyle(int index) {
    Color labelColor = _generateItemColor(index);
    return TextStyle(color: labelColor).textW600().text12();
  }

  /// Generate icon for each item
  Widget _generateIcon(int index) {
    SvgGenImage icon = images[index];
    return Column(
      children: [
        icon.svg(
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(_generateItemColor(index), BlendMode.srcIn),
        ),
        Text(labels[index], style: _generateTextStyle(index))
      ],
    );
  }

  void _onTap(int index) {
    setState(() {
      selectedIndex = index;
      context.goTo(routeNames[index]);
    });
  }

  BottomNavigationBarItem _generateItem(int index) {
    return BottomNavigationBarItem(
      icon: _generateIcon(index),
      label: '',
    );
  }
}
