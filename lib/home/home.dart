import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/cycle_progress/cycle_progress.dart';
import 'package:women_diary/home/home_component/quick_action.dart';
import 'package:women_diary/home/home_component/quick_stats.dart';
import 'package:women_diary/home/home_component/upcoming_schedule.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/schedule/schedule_model.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(LoadCycleEvent()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CycleProgress(),
              Constants.vSpacer40,
              _buildQuickStats(),
              Constants.vSpacer24,
              const Text('Ghi nhanh').w700(),
              Constants.vSpacer16,
              _quickActions(),
              Constants.vSpacer16,
              _upcomingSchedule(),
              Constants.vSpacer20,
              _setting(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _upcomingSchedule() {
    return BlocSelector<HomeBloc, HomeState, ScheduleModel?>(
      selector: (state) => state.nextSchedule,
      builder: (context, nextSchedule) {
        if (nextSchedule == null) return const SizedBox.shrink();
        return UpComingSchedule(schedule: nextSchedule);
      },
    );
  }

  Widget _buildQuickStats() {
    return BlocSelector<HomeBloc, HomeState, CycleData?>(
      selector: (state) => (state.cycle),
      builder: (context, data) {
        return QuickStats(
          cycleData: data
        );
      },
    );
  }

  Widget _quickActions() {
    return Row(
      children: [
        Expanded(
          child: QuickAction(
            title: "Ghi Action",
            emoji: "✍️",
            background: Colors.pink.shade100,
            foreground: Colors.white,
            border: BorderSide(color: Colors.transparent),
            onTap: () => context.navigateTo(RoutesName.newAction),
          ),
        ),
        Constants.hSpacer12,
        Expanded(
            child: QuickAction(
                title: "Ghi Schedule",
                emoji: "📌",
                background: Colors.white,
                foreground: Colors.pink,
                border: BorderSide(color: Colors.pink.shade200),
                onTap: () => context.navigateTo(RoutesName.newSchedule)
            )
        ),
      ],
    );
  }

  Widget _setting() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple.shade100,
          foregroundColor: Colors.purple.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        icon: const Icon(Icons.settings),
        label: const Text("Thiết lập cá nhân").text16().w700(),
        onPressed: () {
          context.navigateTo(RoutesName.setting).then((value) => context.read<HomeBloc>().add(LoadCycleEvent()));
        },
      ),
    );
  }
}
