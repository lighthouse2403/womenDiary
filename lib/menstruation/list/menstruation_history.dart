import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/widgets/empty_view.dart';
import 'package:women_diary/menstruation/bloc/menstruation_bloc.dart';
import 'package:women_diary/menstruation/bloc/menstruation_event.dart';
import 'package:women_diary/menstruation/bloc/menstruation_state.dart';
import 'package:women_diary/menstruation/list/menstruation_row.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';
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
              context.navigateTo(RoutesName.menstruationCalendar, arguments:  context.read<MenstruationBloc>().menstruationList).then((_) {
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
      body: _menstruationList()
    );
  }

  Widget _menstruationList() {
    return BlocBuilder<MenstruationBloc, MenstruationState>(
      buildWhen: (pre, current) => current is LoadedAllMenstruationState,
      builder: (context, state) {
        List<MenstruationModel> list = state is LoadedAllMenstruationState ? state.menstruationList : [];
        print('_menstruationList ${list.length}');
        return list.isNotEmpty
            ? _list(list)
            : EmptyView(
                title: 'Chưa có kỳ kinh nào',
                content: 'Hãy bắt đầu ghi lại để theo dõi chu kỳ của bạn.'
              );
        },
    );
  }

  Widget _list(List<MenstruationModel> list) {
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
                      startTime: menstruation.startTime.startOfDay(),
                      endTime: menstruation.endTime.startOfDay(),
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
              shadowColor: AppColors.mainColor.withAlpha(40),
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
}
