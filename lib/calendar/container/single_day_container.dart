import 'package:flutter/material.dart';
import 'dart:async';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/calendar/components/stroke_text.dart';
import 'package:women_diary/calendar/components/swipe_detector.dart';
import 'package:women_diary/calendar/model/quote_VO.dart';
import 'package:women_diary/calendar/services/data_service.dart';
import 'package:women_diary/calendar/utils/date_utils.dart';
import 'package:women_diary/calendar/utils/lunar_solar_utils.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:go_router/go_router.dart';

class SingleDayContainer extends StatefulWidget {
  const SingleDayContainer({super.key});
  @override
  State createState() {
    return _SingleDayContainerState();
  }
}

class _SingleDayContainerState extends State<SingleDayContainer>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<SingleDayContainer> {
  List<QuoteVO> _quoteData = [];
  DateTime _selectedDate = DateTime.now();
  late Timer _timer;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _getData();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _controller.value = 0.8;
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
    Duration oneSec = const Duration(seconds: 2);
    _timer = Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              DateTime now = DateTime.now();
              _selectedDate = DateTime(_selectedDate.year, _selectedDate.month,
                  _selectedDate.day, now.hour, now.minute, now.second);
            }));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  _getData() async {
    var data = await loadQuoteData();
    setState(() {
      _quoteData = data;
    });
  }

  _onSwipeLeft() {
    _controller.value = 0.8;
    _controller.forward();
    setState(() {
      _selectedDate = decreaseDay(_selectedDate);
    });
  }

  _onSwipeRight() {
    _controller.value = 0.8;
    _controller.forward();
    setState(() {
      _selectedDate = increaseDay(_selectedDate);
    });
  }

  Future<Null> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(1920, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget paddingText(double top, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(text, style: style).center(),
    );
  }

  Widget getMainDate() {
    var dayOfWeek = getNameDayOfWeek(_selectedDate);
    var quote = QuoteVO("", "");
    if (_quoteData.isNotEmpty) {
      quote = _quoteData[_selectedDate.day % _quoteData.length];
    }

    return Expanded(
      child: SwipeDetector(
        onSwipeRight: () {
          _onSwipeRight();
        },
        onSwipeLeft: () {
          _onSwipeLeft();
        },
        child: FadeTransition(
          opacity: _animation,
          child: (
              Stack(
            children: <Widget>[
              const Positioned.fill(
                child: Image(
                  image: AssetImage('assets/images/pregnancy_backgroound_3.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: StrokeText(
                          _selectedDate.day.toString(),
                          FontWeight.w700,
                          fontSize: 120,
                          color: Constants.primaryTextColor(),
                          strokeColor: Colors.white,
                          strokeWidth: 0
                      )
                  ),
                  Text(dayOfWeek).w700().text20().primaryTextColor().center(),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(quote.content).w400().text16().blackColor().center(),
                          Constants.vSpacer30,
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(quote.author).w600().text14().blackColor(),
                          ),
                        ],
                      ),
                    )
                  ),
                  getDateInfo()
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget infoBox(Widget widget, bool hasBorder) {
    return Expanded(
      child: (Container(
        padding: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border: Border(right: BorderSide(color: Colors.grey, width: hasBorder ? 1 : 0))),
        child: widget,
      )),
    );
  }

  Widget getDateInfo() {
    var headerStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
    var bodyStyle = const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);
    var bottomStyle = const TextStyle(color: Colors.black);
    var dayStyle = const TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold);
    var hourMinute = '${_selectedDate.hour}:${_selectedDate.minute}';
    var lunarDates = convertSolar2Lunar(
        _selectedDate.day, _selectedDate.month, _selectedDate.year, 7);
    var lunarDay = lunarDates[0];
    var lunarMonth = lunarDates[1];
    var lunarYear = lunarDates[2];
    var lunarMonthName = getCanChiMonth(lunarMonth, lunarYear);

    var jd = jdn(_selectedDate.day, _selectedDate.month, _selectedDate.year);
    var dayName = getCanDay(jd);
    var beginHourName = getBeginHour(jd);
    return Container(
      height: 120,
      color: Colors.white.withAlpha(125),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            infoBox(
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Giờ", style: headerStyle).blackColor(),
                    Text(hourMinute, style: bodyStyle).blackColor(),
                    Text(beginHourName, style: bottomStyle).blackColor(),
                  ],
                ),
                true),
            infoBox(
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Ngày", style: headerStyle).blackColor(),
                    Text(lunarDay.toString(), style: dayStyle).blackColor(),
                    Text(dayName, style: bottomStyle).blackColor(),
                  ],
                ),
                true),
            infoBox(
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Tháng", style: headerStyle).blackColor(),
                    Text(lunarMonth.toString(), style: bodyStyle).blackColor(),
                    Text(lunarMonthName, style: bottomStyle).blackColor(),
                  ],
                ),
                false)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var title = 'Tháng ${_selectedDate.month} - ${_selectedDate.year}';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: InkWell(
          onTap: () async {
            _showDatePicker(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title).w500().text16().whiteColor(),
              const SizedBox(height: 4),
              Assets.icons.arrowDown.svg(
                  width: 16,
                  height: 16,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn)
              )
            ],
          ),
        ),
        leading: InkWell(
          onTap: () => context.pop(),
          child: Align(
            alignment: Alignment.center,
            child: Assets.icons.arrowBack.svg(width: 24, height: 24),
          ),
        ),
        actions: [
          InkWell(
            onTap: (){
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              child: const Text("Hôm Nay").w500().text14().whiteColor(),
            ),
          )
        ],
      ),
      body: Material(
          child: Column(
            children: [
              getMainDate(),
            ],
          )
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}
