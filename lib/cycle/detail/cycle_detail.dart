import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/bloc/cycle_state.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleDetail extends StatelessWidget {
  final CycleModel cycle;
  final dateFormat = DateFormat('dd/MM/yyyy');

  CycleDetail({super.key, required this.cycle});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CycleBloc()..add(LoadCycleDetailEvent(cycle)),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: BaseAppBar(
          backgroundColor: Colors.pink[200],
          hasBack: true,
          title: 'Chi tiết',
          actions: [
            IconButton(
              onPressed: () {
                context.read<CycleBloc>().add(UpdateCycleEvent());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save, color: Colors.white),
            ),
          ],
        ),
        body: BlocBuilder<CycleBloc, CycleState>(
          builder: (context, state) {
            CycleModel cycle = state is LoadedCycleDetailState ? state.cycle : CycleModel(DateTime.now());
            return ListView(
              padding: const EdgeInsets.all(16),
              children:  [
                  _cycleInformation(cycle),
                  const SizedBox(height: 20),
                  _timeLine(cycle),
                  const Divider(height: 30),
                  _note(context, cycle),
                ],
            );
          },
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label).w500()),
          Text(value).w600().customColor(Colors.pink.shade400),
        ],
      ),
    );
  }

  Widget _cycleInformation(CycleModel cycle) {
    final cycleDays =
        cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final menstruationDays =
        cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final ovulationDate =
    cycle.cycleEndTime.subtract(const Duration(days: 14));

    return Column(
      children: [
        buildInfoRow('Bắt đầu', dateFormat.format(cycle.cycleStartTime)),
        buildInfoRow('Kết thúc', dateFormat.format(cycle.cycleEndTime)),
        const Divider(height: 24),
        buildInfoRow('Số ngày chu kỳ', '$cycleDays ngày'),
        buildInfoRow('Số ngày kinh nguyệt', '$menstruationDays ngày'),
        buildInfoRow('Ngày rụng trứng', dateFormat.format(ovulationDate)),
      ],
    );
  }

  Widget _note(BuildContext context, CycleModel cycle) {
    final controller = TextEditingController(text: cycle.note);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Ghi chú', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Nhập ghi chú...',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
          maxLines: 4,
          onChanged: (value) =>
              context.read<CycleBloc>().add(UpdateCycleNoteEvent(value)),
        ),
      ],
    );
  }

  Widget _timeLine(CycleModel cycle) {
    int cycleDays = cycle.cycleEndTime.difference(cycle.cycleStartTime).inDays + 1;
    int menstruationDays = cycle.menstruationEndTime.difference(cycle.cycleStartTime).inDays + 1;
    final ovulationDate = cycle.cycleEndTime.subtract(const Duration(days: 14));
    final ovulationIndex = ovulationDate.difference(cycle.cycleStartTime).inDays + 1;
    final follicularDays = ovulationIndex - menstruationDays;
    final lutealDays = cycleDays - ovulationIndex;

    double mensWidth = menstruationDays / cycleDays;
    double follicularWidth = follicularDays / cycleDays;
    double ovulationWidth = 1 / cycleDays;
    double lutealWidth = lutealDays / cycleDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Diễn biến chu kỳ',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Row(
            children: [
              _animatedPhase(mensWidth, Colors.pink.shade300, '💗 ${menstruationDays}'),
              _animatedPhase(follicularWidth, Colors.pink.shade100, '🌱 ${follicularDays}'),
              _animatedPhase(ovulationWidth, Colors.amber.shade300, '🌸'),
              _animatedPhase(lutealWidth, Colors.purple.shade100,'💜 ${lutealDays}'),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _legendItem(Colors.pink.shade300, 'Kinh nguyệt 💗'),
            _legendItem(Colors.pink.shade100, 'Nang trứng 🌱'),
            _legendItem(Colors.amber.shade300, 'Rụng trứng 🌸'),
            _legendItem(Colors.purple.shade100, 'Hoàng thể 💜'),
          ],
        ),
      ],
    );
  }

  Widget _animatedPhase(double ratio, Color color, String text) {
    return Expanded(
      flex: (ratio * 1000).round(),
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: 0, end: 1),
        builder: (context, value, child) {
          return FractionallySizedBox(
            widthFactor: value,
            alignment: Alignment.centerLeft,
            child: Container(
              height: 22,
              color: color,
              child: Text(text).text12().w500().greyColor(),
            ),
          );
        },
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }


}

