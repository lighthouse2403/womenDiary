import 'package:baby_diary/baby_index/baby_height/baby_height_row.dart';
import 'package:baby_diary/baby_index/baby_height/bloc/baby_height_bloc.dart';
import 'package:baby_diary/baby_index/baby_height/bloc/baby_height_event.dart';
import 'package:baby_diary/baby_index/baby_height/bloc/baby_height_state.dart';
import 'package:baby_diary/baby_index/index_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';

class HeightList extends BaseStatefulWidget {
  HeightList({super.key});

  @override
  State<HeightList> createState() => _DiaryListState();
}

class _DiaryListState extends BaseStatefulState<HeightList> {
  BabyHeightBloc heightBloc = BabyHeightBloc();

  @override
  void initState() {
    heightBloc.add(const LoadBabyHeightEvent());
    super.initState();
  }
  @override
  PreferredSizeWidget? buildAppBar() {
    return BaseAppBar(
      title: 'Nhật ký',
      actions: [
        InkWell(
          onTap: () {
            context.navigateTo(
                RoutesName.heightDetail
            ).then((value) => heightBloc.add(const LoadBabyHeightEvent()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Assets.icons.add.svg(width: 24, height: 24),
          ),
        )
      ],
    );
  }

  @override
  Widget? buildBody() {
    return BlocProvider(
        create: (context) => heightBloc,
        child: BlocListener<BabyHeightBloc, BabyHeightState> (
            listener: (context, state) {

            },
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/pregnancy_backgroound_3.jpg'),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                  child: ListView.builder(
                    itemCount: heightBloc.heightList.length,
                    itemBuilder: (context, int index) {
                      return
                        InkWell(
                          onTap: () {
                            context.navigateTo(
                                RoutesName.heightDetail,
                                arguments: heightBloc.heightList[index]
                            ).then((value) => heightBloc.add(const LoadBabyHeightEvent()));
                          },
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) {
                                    IndexModel height = heightBloc.heightList[index];
                                    heightBloc.add(DeleteBabyHeightEvent(height));
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Xoá',
                                )
                              ],
                            ),
                            child: BabyHeightRow(height: heightBloc.heightList[index]),
                          ),
                        );
                    },
                  )
              ),
            )
        )
    );
  }
}
