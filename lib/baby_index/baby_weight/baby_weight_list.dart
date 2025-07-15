import 'package:baby_diary/baby_index/baby_weight/baby_weight_row.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_bloc.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_event.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';

class BabyWeightList extends BaseStatefulWidget {
  const BabyWeightList({super.key});

  @override
  State<BabyWeightList> createState() => _BabyWeightListState();
}

class _BabyWeightListState extends BaseStatefulState<BabyWeightList> {
  BabyWeightBloc babyWeightBloc = BabyWeightBloc();

  @override
  void initState() {
    babyWeightBloc.add(const LoadBabyWeightEvent());
    super.initState();
  }
  @override
  PreferredSizeWidget? buildAppBar() {
    return BaseAppBar(
      title: 'Cân nặng bé yêu',
      actions: [
        InkWell(
          onTap: () {
            context.navigateTo(
                RoutesName.weightDetail
            ).then((value) => babyWeightBloc.add(const LoadBabyWeightEvent()));
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
        create: (context) => babyWeightBloc,
        child: BlocListener<BabyWeightBloc, BabyWeightState> (
            listener: (context, state) {
              if (state is LoadingBabyWeightSuccessful) {
                setState(() {
                });
              }
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
                    itemCount: babyWeightBloc.babyWeightList.length,
                    itemBuilder: (context, int index) {
                      return
                        InkWell(
                          onTap: () {
                            context.navigateTo(
                                RoutesName.weightDetail,
                                arguments: babyWeightBloc.babyWeightList[index]
                            ).then((value) => babyWeightBloc.add(const LoadBabyWeightEvent()));
                          },
                          child: Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (BuildContext context) {
                                    String id = babyWeightBloc.babyWeightList[index].id;
                                    babyWeightBloc.add(DeleteBabyWeightEvent(id));
                                  },
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Xoá',
                                )
                              ],
                            ),
                            child: BabyWeightRow(babyWeight: babyWeightBloc.babyWeightList[index]),
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
