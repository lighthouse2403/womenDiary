import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/menstruation/bloc/menstruation_bloc.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/menstruation_row.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class MenstruationHistory extends StatelessWidget {
  const MenstruationHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MenstruationBloc()..add(const LoadAllMenstruationEvent()),
      child: const _MenstruationHistoryView(),
    );
  }
}

class _MenstruationHistoryView extends StatefulWidget {
  const _MenstruationHistoryView({super.key});

  @override
  State<_MenstruationHistoryView> createState() => _MenstruationHistoryViewState();
}

class _MenstruationHistoryViewState extends State<_MenstruationHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Lịch sử',
        actions: [
          InkWell(
            onTap: () {
              context.navigateTo(RoutesName.menstruationCalendar).then((_) {
                context.read<MenstruationBloc>().add(const LoadAllMenstruationEvent());
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Assets.icons.add.svg(width: 28, height: 28, colorFilter: ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn)),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenstruationBloc, MenstruationState>(
        builder: (context, state) {
          if (state is LoadedAllMenstruationState) {
            final mestruationList = state.menstruationList;

            if (mestruationList.isEmpty) {
              return const Center(child: Text('Không có dữ liệu'));
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: mestruationList.length,
              itemBuilder: (context, index) {
                final menstruation = mestruationList[index];
                return InkWell(
                  onTap: () {
                    context.navigateTo(
                      RoutesName.menstruationDetail,
                      arguments: menstruation,
                    );
                  },
                  child: Slidable(
                    key: ValueKey(menstruation.startTime.millisecondsSinceEpoch),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          onPressed: (_) {
                            context.read<MenstruationBloc>().add(
                              DeleteMenstruationEvent(
                                startTime: menstruation.startTime.millisecondsSinceEpoch,
                                endTime: menstruation.endTime.millisecondsSinceEpoch,
                              ),
                            );
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Xoá',
                        ),
                      ],
                    ),
                    child: MenstruationRow(menstruation: menstruation),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('Không có dữ liệu'));
          }
        },
      ),
    );
  }
}
