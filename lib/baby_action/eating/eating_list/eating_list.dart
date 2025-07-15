import 'package:baby_diary/baby_action/eating/bloc/eating_bloc.dart';
import 'package:baby_diary/baby_action/eating/bloc/eating_event.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EatingList extends StatelessWidget {
  const EatingList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EatingBloc()..add(LoadEatingHistoryByDateEvent(DateTime.now())),
      child: const _EatingListView(),
    );
  }
}

class _EatingListView extends BaseStatefulWidget {
  const _EatingListView();

  @override
  State<_EatingListView> createState() => _EatingListViewState();
}

class _EatingListViewState extends BaseStatefulState<_EatingListView> {
  @override
  PreferredSizeWidget? buildAppBar() {
    return BaseAppBar(
      title: 'Bé ăn',
      actions: [
        InkWell(
          onTap: (){},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text('Thêm').w500().text14().whiteColor(),
          ),
        ),
      ],
    );
  }

  @override
  Widget? buildBody() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/pregnancy_background_3.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(),
    );
  }
}

