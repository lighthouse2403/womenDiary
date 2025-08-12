import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/widgets/empty_view.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/list/cycle_row.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class CycleHistory extends StatelessWidget {
  const CycleHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()..add(const LoadAllCycleEvent()),
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
              context.navigateTo(RoutesName.cycleCalendar, arguments:  context.read<CycleBloc>().cycleList).then((_) {
                context.read<CycleBloc>().add(const LoadAllCycleEvent());
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
    return BlocBuilder<CycleBloc, CycleState>(
      buildWhen: (pre, current) => current is LoadedAllCycleState,
      builder: (context, state) {
        List<CycleModel> list = state is LoadedAllCycleState ? state.cycleList : [];
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

  Widget _list(List<CycleModel> list) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cycle = list[index];

        return Slidable(
          key: ValueKey(cycle.cycleStartTime.millisecondsSinceEpoch),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<CycleBloc>().add(
                    DeleteCycleEvent(cycle.id),
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
                RoutesName.cycleDetail,
                arguments: cycle,
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
                child: CycleRow(cycle: cycle),
              ),
            ),
          ),
        );
      },
    );
  }
}
