import 'package:flutter/material.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/cycle/bloc/cycle_bloc.dart';
import 'package:women_diary/cycle/cycle_model.dart';

class CycleDetail extends StatefulWidget {
  const CycleDetail({super.key, required this.cycle});

  final CycleModel cycle;
  @override
  State<CycleDetail> createState() => _CycleDetailState();
}

class _CycleDetailState extends State<CycleDetail> {
  CycleBloc menstruationBloc = CycleBloc();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '${widget.cycle.cycleStartTime.globalDateFormat()} ~ ${widget.cycle.cycleEndTime.globalDateFormat()}'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text('Start time: ${widget.cycle.cycleStartTime.globalDateFormat()}'),
            Constants.vSpacer10,
            Text('End time: ${widget.cycle.cycleEndTime.globalDateFormat()}'),
            Text('Note: ${widget.cycle.note}'),
          ],
        ),
      )
    );
  }
}
