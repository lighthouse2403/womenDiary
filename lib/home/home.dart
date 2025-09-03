import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/app_card.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/home/pretty_cycle_painter.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:women_diary/schedule/schedule_model.dart';

/// Extension để lấy dữ liệu an toàn từ state
extension CycleStateX on HomeState {
  int get currentDay =>
      this is LoadedCycleState ? (this as LoadedCycleState).currentDay : 0;
  int get cycleLength =>
      this is LoadedCycleState ? (this as LoadedCycleState).cycleLength : 30;
  int get daysUntilNext =>
      this is LoadedCycleState ? (this as LoadedCycleState).daysUntilNext : 30;
  List<PhaseModel> get phases =>
      this is LoadedCycleState ? (this as LoadedCycleState).phases : [];
  ScheduleModel? get nextSchedule =>
      this is LoadedScheduleState ? (this as LoadedScheduleState).schedules.first : null;
}

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
              _shortCreate(),
              Constants.hSpacer12,
              _setting(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shortCreate() {
    return Row(
      children: [
        Expanded(
          child: _quickActionCard(
            title: "Ghi Action",
            emoji: "✍️",
            background: Colors.pink.shade100,
            foreground: Colors.white,
            onTap: () => context.navigateTo(RoutesName.newAction),
          ),
        ),
        Constants.hSpacer12,
        Expanded(
          child: _quickActionCard(
            title: "Ghi Schedule",
            emoji: "📌",
            background: Colors.white,
            foreground: Colors.pink,
            border: BorderSide(color: Colors.pink.shade200),
            onTap: () => context.navigateTo(RoutesName.newSchedule),
          ),
        ),
      ],
    );
  }

  Widget _cycleProgress(double screenWidth) {
    final circleSize = screenWidth - 60.0;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (pre, cur) => cur is LoadedCycleState || cur is LoadedScheduleState,
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
          color: Colors.orange.shade100.withOpacity(0.4),
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
                const Text("Lịch hẹn sắp tới",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(dateStr,
                    style: const TextStyle(fontSize: 14, color: Colors.black87)),
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
          Text("Ngày $currentDay",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              )),
          Constants.vSpacer4,
          Text("Chu kỳ $cycleLength ngày",
              style: const TextStyle(fontSize: 12, color: Colors.black45)),
          Constants.vSpacer6,
          const Text("Giai đoạn: 🌼").text12().black87Color(),
          Constants.vSpacer4,
          const Text("Tiếp theo: 🌙",
              style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
          Text("Còn $daysUntilNext ngày",
              style: const TextStyle(fontSize: 12, color: Colors.orange)),
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

        final expectedEnd =
        DateTime.now().add(Duration(days: daysUntilNext));
        final endStr = DateFormat('dd/MM/yyyy').format(expectedEnd);

        final tiles = <Widget>[
          _statCard(title: "📊 Trung bình chu kỳ", value: "$cycleLength ngày"),
          _statCard(title: "📅 Ngày hiện tại", value: "Ngày $currentDay"),
          _statCard(title: "🔮 Dự kiến kết thúc", value: endStr),
          _statCard(title: "⏱ Chu kỳ ngắn nhất", value: "—"),
          _statCard(title: "⏳ Chu kỳ dài nhất", value: "—"),
          _statCard(title: "✨ Dự kiến độ dài kỳ này", value: "$cycleLength ngày"),
        ];

        final width = (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: tiles.map((e) => SizedBox(width: width, child: e)).toList(),
        );
      },
    );
  }

  Widget _statCard({required String title, required String value}) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.pink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickActionCard({
    required String title,
    required String emoji,
    required Color background,
    required Color foreground,
    BorderSide? border,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: AppCard(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: border != null ? Border.fromBorderSide(border) : null,
        shadows: [
          BoxShadow(
            color: Colors.pink.shade200.withAlpha(60),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: foreground,
              ),
            ),
          ],
        ),
      ),
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
            icon: const Text("🧘‍♀️", style: TextStyle(fontSize: 18)),
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
            icon: const Text("🌸", style: TextStyle(fontSize: 18)),
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
        label: const Text(
          "Thiết lập cá nhân",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        onPressed: () {
          context.navigateTo(RoutesName.setting);
        },
      ),
    );
  }
}
