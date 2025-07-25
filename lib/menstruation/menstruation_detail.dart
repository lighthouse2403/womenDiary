import 'package:flutter/material.dart';
import 'package:women_diary/common/base/base_app_bar.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/menstruation/bloc/menstruation_bloc.dart';
import 'package:women_diary/menstruation/menstruation_model.dart';

class MenstruationDetail extends StatefulWidget {
  const MenstruationDetail({super.key, required this.menstruation});

  final MenstruationModel menstruation;
  @override
  State<MenstruationDetail> createState() => _MenstruationDetailState();
}

class _MenstruationDetailState extends State<MenstruationDetail> {
  MenstruationBloc menstruationBloc = MenstruationBloc();
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(title: '${widget.menstruation.startTime.globalDateFormat()} ~ ${widget.menstruation.endTime.globalDateFormat()}'),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            Text('Start time: ${widget.menstruation.startTime.globalDateFormat()}'),
            Constants.vSpacer10,
            Text('End time: ${widget.menstruation.startTime.globalDateFormat()}'),
            Text('Note: ${widget.menstruation.note}'),
          ],
        ),
      )
    );
  }
}
