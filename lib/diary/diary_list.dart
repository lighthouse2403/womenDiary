import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/base/base_statefull_widget.dart';
import 'package:women_diary/diary/bloc/diary_bloc.dart';
import 'package:women_diary/diary/bloc/diary_event.dart';
import 'package:women_diary/diary/bloc/diary_state.dart';
import 'package:women_diary/diary/diary_row.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class DiaryList extends BaseStatefulWidget {
  const DiaryList({super.key});

  @override
  State<DiaryList> createState() => _DiaryListState();
}

class _DiaryListState extends BaseStatefulState<DiaryList> {
  DiaryBloc diaryBloc = DiaryBloc();

  @override
  void initState() {
    diaryBloc.add(const LoadDiariesEvent());
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
                RoutesName.diaryDetail
            ).then((value) => diaryBloc.add(const LoadDiariesEvent()));
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
        create: (context) => diaryBloc,
        child: BlocListener<DiaryBloc, DiaryState> (
            listener: (context, state) {
              if (state is LoadingSuccessfulState) {
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
                                  String id = diaryBloc.diaries[index].id ?? '';
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
    );
  }
}
