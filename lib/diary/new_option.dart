import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/diary/bloc/diary_bloc.dart';
import 'package:baby_diary/diary/bloc/diary_event.dart';
import 'package:baby_diary/diary/bloc/diary_state.dart';
import 'package:baby_diary/diary/diary_row.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:baby_diary/routes/routes.dart';
import 'package:blur/blur.dart';

class OptionList extends BaseStatefulWidget {
  const OptionList({super.key});

  @override
  State<OptionList> createState() => _OptionListState();
}

class _OptionListState extends BaseStatefulState<OptionList> {
  DiaryBloc diaryBloc = DiaryBloc();

  @override
  void initState() {
    diaryBloc.add(const LoadDiariesEvent());
    super.initState();
  }

  @override
  Widget? buildBody() {
    return BlocProvider(
        create: (context) => diaryBloc,
        child: BlocListener<DiaryBloc, DiaryState> (
            listener: (context, state) {
              if (state is LoadingSuccessfulState) {
                setState(() {
                });
              }
            },
            child: Blur(
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
                      itemCount: diaryBloc.diaries.length,
                      itemBuilder: (context, int index) {
                        return
                          InkWell(
                            onTap: () {
                              context.navigateTo(
                                  RoutesName.diaryDetail,
                                  arguments: diaryBloc.diaries[index]
                              ).then((value) => diaryBloc.add(const LoadDiariesEvent()));
                            },
                            child: Slidable(
                              key: const ValueKey(0),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    flex: 2,
                                    onPressed: (BuildContext context) {
                                      String id = diaryBloc.diaries[index].id;
                                      diaryBloc.add(DeleteDiaryEvent(id));
                                    },
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Xoá',
                                  )
                                ],
                              ),
                              child: DiaryRow(diary: diaryBloc.diaries[index]),
                            ),
                          );
                      },
                    )
                ),
              )
            )
        )
    );
  }
}
