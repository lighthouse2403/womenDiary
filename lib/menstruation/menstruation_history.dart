import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/base/base_statefull_widget.dart';
import 'package:women_diary/diary/bloc/diary_state.dart';
import 'package:women_diary/menstruation/bloc/menstruation_bloc.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';
import 'package:women_diary/menstruation/menstruation_row.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class MenstruationHistory extends StatefulWidget {
  const MenstruationHistory({super.key});

  @override
  State<MenstruationHistory> createState() => _MenstruationHistoryState();
}

class _MenstruationHistoryState extends State<MenstruationHistory> {
  MenstruationBloc menstruationBloc = MenstruationBloc()..add(const LoadAllMenstruationEvent());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Lịch sử',
        actions: [
          InkWell(
            onTap: () {
              context.navigateTo(
                  RoutesName.menstruationDetail
              ).then((value) => menstruationBloc.add(const LoadAllMenstruationEvent()));
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Assets.icons.add.svg(width: 24, height: 24),
            ),
          )
        ],
      ),
      body: BlocProvider(
          create: (context) => menstruationBloc,
          child: BlocListener<MenstruationBloc, MenstruationState> (
              listener: (context, state) {
                if (state is LoadedAllMenstruationState) {
                  setState(() {
                  });
                }
              },
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: SafeArea(
                    child: ListView.builder(
                      itemCount: menstruationBloc.menstruationList.length,
                      itemBuilder: (context, int index) {
                        return
                          InkWell(
                            onTap: () {
                              context.navigateTo(
                                  RoutesName.menstruationDetail,
                                  arguments: menstruationBloc.menstruationList[index]
                              );
                            },
                            child: Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 2,
                                    onPressed: (BuildContext context) {
                                      MenstruationModel menstruation = menstruationBloc.menstruationList[index];
                                      menstruationBloc.add(DeleteMenstruationEvent(startTime: menstruation.startTime.millisecondsSinceEpoch, endTime: menstruation.endTime.millisecondsSinceEpoch));
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Xoá',
                                  )
                                ],
                              ),
                              child: MenstruationRow(menstruation: menstruationBloc.menstruationList[index]),
                            ),
                          );
                      },
                    )
                ),
              )
          )
      ),
    );
  }
}
