import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/common/widgets/loading_view.dart';

class BaseStatefulWidget extends StatefulWidget {
  const BaseStatefulWidget({super.key});

  @override
  State<StatefulWidget> createState() => BaseStatefulState<BaseStatefulWidget>();
}

class BaseStatefulState<T extends StatefulWidget> extends State<T> {
  late double screenWidth;
  final LoadingView loadingView = LoadingView();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  PreferredSizeWidget? buildAppBar() {
    return null;
  }

  Widget? buildBody() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}

