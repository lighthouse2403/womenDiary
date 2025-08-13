import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
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
              context
                  .navigateTo(
                RoutesName.cycleCalendar,
                arguments: context.read<CycleBloc>().cycleList,
              )
                  .then((_) {
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
    final maxDays = list
        .map((e) => e.cycleEndTime.difference(e.cycleStartTime).inDays + 1)
        .fold<int>(0, (prev, e) => e > prev ? e : prev);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: list.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final cycle = list[index];

        // Giữ nguyên công thức từ file cũ
        final int? cycleDays = cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;

        final int? menstruationDays = cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;

        final double totalRatio = (cycleDays != null && maxDays > 0)
            ? cycleDays / maxDays
            : 0;
        final double menstruationRatio = (menstruationDays != null && maxDays > 0)
            ? menstruationDays / maxDays
            : 0;

        final bool isLongest = (cycleDays != null && cycleDays == maxDays);

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
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: isLongest
                    ? Border.all(color: Colors.pink.shade200, width: 1.5)
                    : null,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100.withAlpha(70),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pink.shade200, Colors.pink.shade50],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(10),
                        child: const Text('🌸', style: TextStyle(fontSize: 22)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          '${dateFormat.format(cycle.cycleStartTime)} - '
                              '${ dateFormat.format(cycle.cycleEndTime)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      const double minLabelWidth = 28.0;

                      final totalWidth = constraints.maxWidth;
                      final rawCycleWidth = totalWidth * totalRatio;
                      final rawMensWidth = totalWidth * menstruationRatio;
                      final double cycleWidth = rawCycleWidth.isFinite
                          ? rawCycleWidth.clamp(0.0, totalWidth)
                          : 0.0;
                      double mensWidth = rawMensWidth.isFinite ? rawMensWidth : 0.0;
                      if (mensWidth > cycleWidth) mensWidth = cycleWidth;

                      final double remainingWidth = (cycleWidth - mensWidth).clamp(0.0, totalWidth);

                      return Container(
                        height: 18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.grey.shade200,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Row(
                          children: [
                            // Menstruation segment (hồng đậm)
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              width: mensWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.red.shade200, Colors.pink.shade200],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: (menstruationDays != null && menstruationDays > 0 && mensWidth >= minLabelWidth)
                                  ? Center(
                                child: Text(
                                  '${menstruationDays}d',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeOutCubic,
                              width: remainingWidth,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.pink.shade100, Colors.pink.shade50],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                              ),
                              child: (cycleDays != null && remainingWidth >= minLabelWidth)
                                  ? Center(
                                child: Text(
                                  '${cycleDays - (menstruationDays ?? 0)}d',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (isLongest)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('🌟 Chu kỳ dài nhất').text13().w600().customColor(Colors.pink.shade400),
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
