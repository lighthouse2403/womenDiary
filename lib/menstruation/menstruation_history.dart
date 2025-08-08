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
  const _MenstruationHistoryView();

  @override
  State<_MenstruationHistoryView> createState() => _MenstruationHistoryViewState();
}

class _MenstruationHistoryViewState extends State<_MenstruationHistoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Lịch sử kỳ kinh',
        actions: [
          IconButton(
            onPressed: () {
              context.navigateTo(RoutesName.menstruationCalendar).then((_) {
                context.read<MenstruationBloc>().add(const LoadAllMenstruationEvent());
              });
            },
            icon: Assets.icons.add.svg(
              width: 28,
              height: 28,
              colorFilter: ColorFilter.mode(AppColors.mainColor, BlendMode.srcIn),
            ),
          ),
        ],
      ),
      body: BlocBuilder<MenstruationBloc, MenstruationState>(
        builder: (context, state) {
          if (state is LoadedAllMenstruationState) {
            final list = state.menstruationList;

            if (list.isEmpty) {
              return _buildEmptyView();
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final menstruation = list[index];

                return Slidable(
                  key: ValueKey(menstruation.startTime.millisecondsSinceEpoch),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    extentRatio: 0.25,
                    children: [
                      SlidableAction(
                        onPressed: (_) {
                          context.read<MenstruationBloc>().add(
                            DeleteMenstruationEvent(
                              startTime: menstruation.startTime.millisecondsSinceEpoch,
                              endTime: menstruation.endTime.millisecondsSinceEpoch,
                            ),
                          );
                        },
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.delete_outline,
                        label: 'Xoá',
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      context.navigateTo(
                        RoutesName.menstruationDetail,
                        arguments: menstruation,
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      shadowColor: AppColors.mainColor.withOpacity(0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: MenstruationRow(menstruation: menstruation),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return _buildEmptyView();
        },
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.icons.calendar.svg(width: 80, height: 80, colorFilter: ColorFilter.mode(Colors.grey.shade400, BlendMode.srcIn)),
          const SizedBox(height: 16),
          Text(
            'Chưa có kỳ kinh nào',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Hãy bắt đầu ghi lại để theo dõi chu kỳ của bạn.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
