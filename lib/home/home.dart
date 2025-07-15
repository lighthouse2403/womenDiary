import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/date_time_extension.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/period/red_date.dart';
import 'package:women_diary/schedule/schedule_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (_) => HomeBloc()..add(const LoadBabyInformationEvent()),
      child: const _HomePageStateful(),
    );
  }
}

class _HomePageStateful extends StatefulWidget {
  const _HomePageStateful();

  @override
  State<_HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<_HomePageStateful> {
  @override
  Widget build(BuildContext context) {
    return const HomeView();
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _babyInformation(),
              _babyActions(),
              _babySchedule()
            ],
          ),
        )
      ),
    );
  }

  Widget _babyInformation() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          _babyInformationRow('Name', '--'),
          _babyInformationRow('Age', '--'),
          _babyInformationRow('Standard weight', '--'),
          _babyInformationRow('Standard height', '--'),
        ],
      )
    );
  }

  Widget _babyInformationRow(String title, String content) {
    return Row(
      children: [
        Text(title).w400().text14().ellipsis(),
        Constants.vSpacer4,
        Expanded(child: Text(content).w500().text14().ellipsis().right())
      ],
    );
  }

  Widget _babyActions() {
    return BlocBuilder(
        buildWhen: (context, state) => state is LoadedRedDateState,
        builder: (context, state) {
          List<RedDateModel> actions = state is LoadedRedDateState ? state.redDate : [];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return _babyActionRow(action);
            },
          );
        }
    );
  }

  Widget _babyActionRow(RedDateModel date) {
    return Row(
      children: [
        Text(date.startTime.globalTimeFormat()).w500().text18().ellipsis(),
        Constants.vSpacer4,
        Expanded(child: Text(date.note).w400().text14().ellipsis().left())
      ],
    );
  }

  Widget _babySchedule() {
    return BlocBuilder(
        buildWhen: (context, state) => state is LoadedScheduleState,
        builder: (context, state) {
          List<ScheduleModel> schedules = state is LoadedScheduleState ? state.schedules : [];
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return _scheduleRow(schedule);
            },
          );
        }
    );
  }

  Widget _scheduleRow(ScheduleModel schedule) {
    return Row(
      children: [
        Text(schedule.time.globalTimeFormat()).w500().text18().ellipsis(),
        Constants.vSpacer4,
        Expanded(child: Text(schedule.note).w400().text14().numberOfLines(6).left())
      ],
    );
  }
}
