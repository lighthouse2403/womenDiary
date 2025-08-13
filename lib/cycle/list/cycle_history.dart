import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/widgets/empty_view.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

class CycleHistory extends StatelessWidget {
  const CycleHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()..add(const LoadAllCycleEvent()),
      child: const _CycleHistoryView(),
    );
  }
}

class _CycleHistoryView extends StatefulWidget {
  const _CycleHistoryView();

  @override
  State<_CycleHistoryView> createState() => _CycleHistoryViewState();
}

class _CycleHistoryViewState extends State<_CycleHistoryView> {
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Lịch sử kỳ kinh',
        actions: [
          IconButton(
            onPressed: () {
              context.navigateTo(
                RoutesName.cycleCalendar,
                arguments: context.read<CycleBloc>().cycleList,
              ).then((_) {
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
      body: BlocBuilder<CycleBloc, CycleState>(
        buildWhen: (pre, current) => current is LoadedAllCycleState,
        builder: (context, state) {
          if (state is LoadedAllCycleState && state.cycleList.isNotEmpty) {
            return _buildCycleList(state.cycleList);
          }
          return const EmptyView(
            title: 'Chưa có kỳ kinh nào',
            content: 'Hãy bắt đầu ghi lại để theo dõi chu kỳ của bạn.',
          );
        },
      ),
    );
  }

  Widget _buildCycleList(List<CycleModel> list) {
    // Tìm chu kỳ dài nhất để so sánh
    final maxDays = list
        .map((e) => e.cycleEndTime != null
        ? e.cycleEndTime!.difference(e.cycleStartTime).inDays + 1
        : 0)
        .fold<int>(0, (prev, e) => e > prev ? e : prev);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final cycle = list[index];
        final cycleDays = cycle.cycleEndTime != null
            ? cycle.cycleEndTime!.difference(cycle.cycleStartTime).inDays + 1
            : null;
        final menstruationDays = cycle.menstruationEndTime != null
            ? cycle.menstruationEndTime!.difference(cycle.cycleStartTime).inDays + 1
            : null;

        // Tính tỷ lệ % để vẽ progress
        final progress = cycleDays != null && maxDays > 0
            ? cycleDays / maxDays
            : 0.0;

        return Slidable(
          key: ValueKey(cycle.cycleStartTime.millisecondsSinceEpoch),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            extentRatio: 0.25,
            children: [
              SlidableAction(
                onPressed: (_) {
                  context.read<CycleBloc>().add(DeleteCycleEvent(cycle.id));
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.pink.shade50,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ngày
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.pink.shade100,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text('🌸', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          '${dateFormat.format(cycle.cycleStartTime)} - '
                              '${cycle.cycleEndTime != null ? dateFormat.format(cycle.cycleEndTime!) : "..."}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 10,
                      backgroundColor: Colors.pink.shade100.withOpacity(0.4),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.pinkAccent.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Info ngày
                  Text(
                    'Chu kỳ: ${cycleDays ?? "--"} ngày • '
                        'Hành kinh: ${menstruationDays ?? "--"} ngày',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  if (cycleDays == maxDays)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '🌟 Dài nhất',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.pink.shade400,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
