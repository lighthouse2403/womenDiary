import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/home/bloc/home_bloc.dart';
import 'package:women_diary/home/bloc/home_event.dart';
import 'package:women_diary/home/bloc/home_state.dart';
import 'package:women_diary/home/phase_model.dart';
import 'package:women_diary/home/pretty_cycle_painter.dart';
import 'package:women_diary/routes/route_name.dart';
import 'package:women_diary/routes/routes.dart';

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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _alertController, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final List<PhaseModel> phases =
            state is LoadedCycleState ? state.phases : [];
            final int currentDay =
            state is LoadedCycleState ? state.currentDay : 0;
            final int cycleLength =
            state is LoadedCycleState ? state.cycleLength : 30;
            final int daysUntilNext =
            state is LoadedCycleState ? state.daysUntilNext : 30;
            final int ovulationDay = cycleLength - 14;

            final screenWidth = MediaQuery.of(context).size.width;
            final circleSize = screenWidth - 60.0;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vòng tròn
                  Center(
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
                            child: _cycleInformation(
                              currentDay,
                              cycleLength,
                              daysUntilNext,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Constants.vSpacer40,
                  _buildQuickStats(context,
                      currentDay: currentDay,
                      cycleLength: cycleLength,
                      daysUntilNext: daysUntilNext),
                  Constants.vSpacer16,

                  // Alert card nếu gần kỳ
                  if (daysUntilNext <= 3)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: _cycleAlertCard(context, daysUntilNext),
                      ),
                    ),
                  Constants.vSpacer16,

                  // ============== LỊCH HẸN SẮP TỚI ==================
                  _upcomingScheduleCard(DateTime.now().add(Duration(days: 1, hours: 8))),
                  Constants.vSpacer24,

                  // GHI NHANH
                  Text(
                    "Ghi nhanh",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Constants.vSpacer16,
                  Row(
                    children: [
                      Expanded(
                        child: _quickActionCard(
                          title: "Ghi Action",
                          emoji: "✍️",
                          background: Colors.pink.shade100,
                          foreground: Colors.white,
                          onTap: () => _showQuickActionSheet(
                            context,
                            type: 'action',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _quickActionCard(
                          title: "Ghi Schedule",
                          emoji: "📌",
                          background: Colors.white,
                          foreground: Colors.pink,
                          border: BorderSide(color: Colors.pink.shade200),
                          onTap: () => _showQuickActionSheet(
                            context,
                            type: 'schedule',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // =========== Upcoming Schedule Card =============
  Widget _upcomingScheduleCard(DateTime schedule) {
    final dateStr = DateFormat("dd/MM/yyyy – HH:mm").format(schedule);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.shade100.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.alarm, color: Colors.deepOrange, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Lịch hẹn sắp tới",
                    style:
                    TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(dateStr,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black87)),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              // TODO: điều hướng sang trang chi tiết lịch hẹn
            },
            child: const Text("Xem"),
          ),
        ],
      ),
    );
  }

  // ====== Minor option ======
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
                  color: Colors.black87)),
          Constants.vSpacer4,
          Text("Chu kỳ $cycleLength ngày",
              style:
              const TextStyle(fontSize: 12, color: Colors.black45)),
          Constants.vSpacer6,
          const Text("Giai đoạn: 🌼").text12().black87Color(),
          Constants.vSpacer4,
          const Text("Tiếp theo: 🌙",
              style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
          Text("Còn $daysUntilNext ngày",
              style:
              const TextStyle(fontSize: 12, color: Colors.orange)),
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

  Widget _buildQuickStats(
      BuildContext context, {
        required int currentDay,
        required int cycleLength,
        required int daysUntilNext,
      }) {
    final now = DateTime.now();
    final expectedEnd = now.add(Duration(days: daysUntilNext));
    final endStr = DateFormat('dd/MM/yyyy').format(expectedEnd);

    // Nếu bạn có dữ liệu lịch sử trong state, hãy thay "—" bằng giá trị thực tế.
    final shortest = "—";
    final longest = "—";
    final expectedLength = "$cycleLength ngày"; // tạm lấy theo kỳ hiện tại
    final averageLength = "$cycleLength ngày"; // tạm lấy theo kỳ hiện tại

    final tiles = <Widget>[
      _statCard(
        title: "📊 Trung bình chu kỳ",
        value: averageLength,
      ),
      _statCard(
        title: "📅 Ngày hiện tại",
        value: "Ngày $currentDay",
      ),
      _statCard(
        title: "🔮 Dự kiến kết thúc",
        value: endStr,
      ),
      _statCard(
        title: "⏱ Chu kỳ ngắn nhất",
        value: shortest,
      ),
      _statCard(
        title: "⏳ Chu kỳ dài nhất",
        value: longest,
      ),
      _statCard(
        title: "✨ Dự kiến độ dài kỳ này",
        value: expectedLength,
      ),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: tiles
          .map((e) => SizedBox(
        width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2,
        child: e,
      ))
          .toList(),
    );
  }

  Widget _statCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.pink.shade50),
      ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
          border: border != null ? Border.fromBorderSide(border) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.pink.shade200.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
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

    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.pink.shade100),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.shade100.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: const [
              Icon(Icons.calendar_today, color: Colors.pink, size: 20),
              SizedBox(width: 8),
              Text(
                "Sắp đến chu kỳ mới",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Hãy xác nhận để theo dõi chu kỳ chính xác hơn.",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),
          hasStarted
              ? ElevatedButton.icon(
            icon: const Text("🧘‍♀️", style: TextStyle(fontSize: 18)),
            label: const Text("Kết thúc kỳ kinh"),
            style: ElevatedButton.styleFrom(
              animationDuration: const Duration(milliseconds: 300),
              elevation: 4,
              backgroundColor: Colors.white,
              foregroundColor: Colors.pink,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              side: BorderSide(color: Colors.pink.shade300),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<HomeBloc>().add(EndMenstruationEvent());
            },
          )
              : ElevatedButton.icon(
            icon: const Text("🌸", style: TextStyle(fontSize: 18)),
            label: const Text("Bắt đầu chu kỳ mới"),
            style: ElevatedButton.styleFrom(
              animationDuration: const Duration(milliseconds: 300),
              elevation: 4,
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              shadowColor: Colors.pinkAccent.withAlpha(80),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              context.read<HomeBloc>().add(StartNewCycleEvent());
            },
          ),
        ],
      ),
    );
  }

  void _showQuickActionSheet(BuildContext context, {required String type}) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.pink.shade100,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                Text(
                  type == 'action' ? "Ghi nhanh Action" : "Ghi nhanh Schedule",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Text("➕", style: TextStyle(fontSize: 20)),
                  title: Text(type == 'action'
                      ? "Tạo action mới"
                      : "Tạo lịch hẹn mới"),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // TODO: điều hướng sang màn hình tạo mới tương ứng
                    // Navigator.pushNamed(context, RouteName.actionCreate);
                    // Navigator.pushNamed(context, RouteName.scheduleCreate);
                  },
                ),
                ListTile(
                  leading: const Text("📝", style: TextStyle(fontSize: 20)),
                  title:
                  Text(type == 'action' ? "Chọn template" : "Chọn lịch nhanh"),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // TODO: mở picker/template tuỳ ý
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
