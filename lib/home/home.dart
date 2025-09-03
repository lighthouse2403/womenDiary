import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/app_card.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/pretty_cycle_painter.dart';
import 'package:women_diary/home/quick_action.dart';
import 'package:women_diary/home/quick_stats.dart';
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
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;
  late final AnimationController _alertController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _alertController, curve: Curves.easeOut));

    _fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _alertController, curve: Curves.easeIn),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _alertController.forward();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _alertController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _cycleProgress(screenWidth),
              Constants.vSpacer40,
              _buildQuickStats(),
              Constants.vSpacer24,
              const Text('Ghi nhanh').w700(),
              Constants.vSpacer16,
              _quickActions(),
              Constants.hSpacer12,
              _setting(),
            ],
          ),
        ),
      ),
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

  Widget _cycleProgress(double screenWidth) {
    final circleSize = screenWidth - 60.0;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (pre, cur) => cur is LoadedCycleState,
      builder: (context, state) {
        final currentDay = state.currentDay;
        final cycleLength = state.cycleLength;
        final daysUntilNext = state.daysUntilNext;
        final phases = state.phases;
        final ovulationDay = cycleLength - 14;
        final nextSchedule = state.nextSchedule;

        return Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(circleSize, circleSize),
                painter: PrettyCyclePainter(
                  currentDay: currentDay,
                  totalDays: cycleLength,
                  phases: phases,
                  rotation: 0.6,
                  ovulationDay: ovulationDay,
                ),
              ),
              ScaleTransition(
                scale: _pulseAnimation,
                child: GestureDetector(
                  onTap: () {
                    _pulseController.stop();
                    _showCycleDialog(
                      currentDay: currentDay,
                      cycleLength: cycleLength,
                      daysUntilNext: daysUntilNext,
                    );
                  },
                  child: _cycleInformation(currentDay, cycleLength, daysUntilNext),
                ),
              ),
              if (daysUntilNext <= 3)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _cycleAlertCard(context, daysUntilNext),
                  ),
                ),
              if (nextSchedule != null) _upcomingScheduleCard(nextSchedule),
            ],
          ),
        );
      },
    );
  }

  Widget _upcomingScheduleCard(ScheduleModel schedule) {
    final dateStr = DateFormat("dd/MM/yyyy – HH:mm").format(schedule.time);

    return AppCard(
      color: Colors.orange.shade50,
      border: Border.all(color: Colors.orange.shade200),
      shadows: [
        BoxShadow(
          color: Colors.orange.shade100.withAlpha(100),
          blurRadius: 8,
          offset: const Offset(0, 4),
        )
      ],
      child: Row(
        children: [
          const Icon(Icons.alarm, color: Colors.deepOrange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Lịch hẹn sắp tới").text15().w700(),
                const SizedBox(height: 4),
                Text(dateStr).black87Color().text14(),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              context.navigateTo(
                RoutesName.scheduleDetail,
                arguments: schedule,
              );
            },
            child: const Text("Xem"),
          ),
        ],
      ),
    );
  }

  Widget _cycleInformation(int currentDay, int cycleLength, int daysUntilNext) {
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withAlpha(90),
        border: Border.all(color: Colors.white70, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Ngày hiện tại").text14().customColor(Colors.black54),
          Text("Ngày $currentDay").black87Color().w700().text24(),
          Constants.vSpacer4,
          Text("Chu kỳ $cycleLength ngày").black87Color().text12(),
          Constants.vSpacer6,
          const Text("Giai đoạn: 🌼").text12().black87Color(),
          Constants.vSpacer4,
          const Text("Tiếp theo: 🌙").text12().customColor(Colors.deepOrange),
          Text("Còn $daysUntilNext ngày").text12().customColor(Colors.orange),
        ],
      ),
    );
  }

  void _showCycleDialog({
    required int currentDay,
    required int cycleLength,
    required int daysUntilNext,
  }) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text("Thông tin giai đoạn"),
        content: Text(
          "Hôm nay là ngày $currentDay\n"
              "Chu kỳ dự kiến: $cycleLength ngày\n"
              "Còn $daysUntilNext ngày tới mốc tiếp theo.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogCtx).pop();
              _pulseController.repeat();
            },
            child: const Text("Đóng"),
          )
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return BlocSelector<HomeBloc, HomeState, (int, int, int)>(
      selector: (state) =>
      (state.currentDay, state.cycleLength, state.daysUntilNext),
      builder: (context, data) {
        final (currentDay, cycleLength, daysUntilNext) = data;

        return QuickStats(
          currentDay: currentDay,
          cycleLength: cycleLength,
          daysUntilNext: daysUntilNext,
        );
      },
    );
  }

  Widget _cycleAlertCard(BuildContext context, int daysUntilNext) {
    final hasStarted = daysUntilNext < 3;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.pink, size: 20),
              const SizedBox(width: 8),
              const Text('Sắp đến chu kỳ mới').w700().pinkColor().text16(),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Hãy xác nhận để theo dõi chu kỳ chính xác hơn.')
              .text14()
              .black87Color(),
          const SizedBox(height: 12),
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
          context.navigateTo(RoutesName.setting);
        },
      ),
    );
  }
}
