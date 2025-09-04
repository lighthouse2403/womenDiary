import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/home_component/app_card.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';

class CycleAlert extends StatelessWidget {
  final int remainDays;

  CycleAlert({
    required this.remainDays
  });

  @override
  Widget build(BuildContext context) {
    final hasStarted = remainDays < 5;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.pink, size: 20),
              Constants.hSpacer8,
              const Text('Sắp đến chu kỳ mới').w700().pinkColor().text16(),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Hãy xác nhận để theo dõi chu kỳ chính xác hơn.')
              .text14()
              .black87Color(),
          Constants.vSpacer12,
          hasStarted
              ? ElevatedButton.icon(
            icon: const Text("🧘‍♀️").text18(),
            label: const Text("Kết thúc kỳ kinh"),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              side: BorderSide(color: Colors.pink.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () =>
                context.read<HomeBloc>().add(EndMenstruationEvent()),
          )
              : ElevatedButton.icon(
            icon: const Text("🌸").text18(),
            label: const Text("Bắt đầu chu kỳ mới"),
            style: ElevatedButton.styleFrom(
              elevation: 4,
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () =>
                context.read<HomeBloc>().add(StartNewCycleEvent()),
          ),
        ],
      ),
    );
  }
}