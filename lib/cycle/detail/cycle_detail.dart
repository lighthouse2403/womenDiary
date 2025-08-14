import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/bloc/cycle_event.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleDetail extends StatefulWidget {
  final CycleModel cycle;

  const CycleDetail({super.key, required this.cycle});

  @override
  State<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends State<CycleDetail> {
  final dateFormat = DateFormat('dd/MM/yyyy');
  final noteController = TextEditingController();

  double mensWidth = 0;
  double follicularWidth = 0;
  double ovulationWidth = 0;
  double lutealWidth = 0;

  @override
  void initState() {
    super.initState();
    noteController.text = widget.cycle.note ?? '';

    // Chạy animation sau khi build xong
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runTimelineAnimation();
    });
  }

  void _runTimelineAnimation() async {
    final cycleDays =
        widget.cycle.cycleEndTime.difference(widget.cycle.cycleStartTime).inDays + 1;
    final menstruationDays =
        widget.cycle.menstruationEndTime.difference(widget.cycle.cycleStartTime).inDays + 1;
    final ovulationDate =
    widget.cycle.cycleEndTime.subtract(const Duration(days: 14));
    final ovulationIndex =
        ovulationDate.difference(widget.cycle.cycleStartTime).inDays + 1;

    final follicularDays = ovulationIndex - menstruationDays;
    final lutealDays = cycleDays - ovulationIndex;

    // Tỉ lệ
    final totalFlex = cycleDays.toDouble();
    setState(() => mensWidth = 0);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => mensWidth = menstruationDays / totalFlex);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => follicularWidth = follicularDays / totalFlex);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => ovulationWidth = 1 / totalFlex);

    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => lutealWidth = lutealDays / totalFlex);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cycleDays =
        widget.cycle.cycleEndTime.difference(widget.cycle.cycleStartTime).inDays + 1;
    final menstruationDays =
        widget.cycle.menstruationEndTime.difference(widget.cycle.cycleStartTime).inDays + 1;
    final ovulationDate =
    widget.cycle.cycleEndTime.subtract(const Duration(days: 14));

    final ovulationIndex =
        ovulationDate.difference(widget.cycle.cycleStartTime).inDays + 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: BaseAppBar(
        title: 'Chi tiết chu kỳ',
        actions: [
          IconButton(
            onPressed: () {
              widget.cycle.note = noteController.text.trim();
              context.read<CycleBloc>().add(UpdateCycleEvent(widget.cycle));
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save, color: Colors.pink),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Bắt đầu', dateFormat.format(widget.cycle.cycleStartTime)),
            _buildInfoRow('Kết thúc', dateFormat.format(widget.cycle.cycleEndTime)),
            const Divider(height: 24),
            _buildInfoRow('Số ngày chu kỳ', '$cycleDays ngày'),
            _buildInfoRow('Số ngày kinh nguyệt', '$menstruationDays ngày'),
            _buildInfoRow('Ngày rụng trứng', dateFormat.format(ovulationDate)),
            const SizedBox(height: 20),
            _buildTimelineAnimated(
              cycleDays: cycleDays,
              menstruationDays: menstruationDays,
              ovulationIndex: ovulationIndex,
            ),
            const Divider(height: 30),
            Text('Ghi chú', style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: noteController,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
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

  Widget _buildTimelineAnimated({
    required int cycleDays,
    required int menstruationDays,
    required int ovulationIndex,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Diễn biến chu kỳ', style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Row(
          children: [
            _animatedPhase(mensWidth, Colors.pink.shade300, '💗'),
            _animatedPhase(follicularWidth, Colors.pink.shade100, '🌱'),
            _animatedPhase(ovulationWidth, Colors.amber.shade300, '🌸'),
            _animatedPhase(lutealWidth, Colors.purple.shade100, '💜'),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 14,
          runSpacing: 8,
          children: [
            _legendItem(Colors.pink.shade300, 'Kinh nguyệt'),
            _legendItem(Colors.pink.shade100, 'Nang trứng'),
            _legendItem(Colors.amber.shade300, 'Rụng trứng'),
            _legendItem(Colors.purple.shade100, 'Hoàng thể'),
          ],
        ),
      ],
    );
  }

  Widget _animatedPhase(double ratio, Color color, String icon) {
    return Expanded(
      flex: (ratio * 1000).toInt(), // flex tỉ lệ
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        height: 28,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ratio > 0
            ? Center(child: Text(icon, style: const TextStyle(fontSize: 16)))
            : null,
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
