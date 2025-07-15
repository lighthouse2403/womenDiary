import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_bloc.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_event.dart';
import 'package:baby_diary/baby_index/baby_weight/bloc/baby_weight_state.dart';
import 'package:baby_diary/baby_index/index_model.dart';
import 'package:baby_diary/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/date_time_extension.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/common/widgets/date_picker/date_picker_2.dart';
import 'package:baby_diary/routes/routes.dart';
import 'package:go_router/go_router.dart';

class BabyWeightDetail extends BaseStatefulWidget {
  BabyWeightDetail({super.key, required this.initialBabyWeight});
  IndexModel initialBabyWeight;

  @override
  State<BabyWeightDetail> createState() => _BabyWeightDetailState();
}

class _BabyWeightDetailState extends BaseStatefulState<BabyWeightDetail> {
  BabyWeightBloc babyWeightBloc = BabyWeightBloc();

  @override
  void initState() {
    babyWeightBloc.add(InitBabyWeightEvent(widget.initialBabyWeight));
    super.initState();
  }

  @override
  PreferredSizeWidget? buildAppBar() {
    DateTime currentTime = babyWeightBloc.currentBabyWeight.time;
    String title = currentTime.globalDateFormat();
    return AppBar(
      title: InkWell(
        onTap: () async {
          _showDatePicker();
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
      backgroundColor: AppColors.mainColor,
      leading: InkWell(
        onTap: () => context.pop(),
        child: Align(
          alignment: Alignment.center,
          child: Assets.icons.arrowBack.svg(width: 24, height: 24),
        ),
      ),
    );
  }

  @override
  Widget? buildBody() {
    return BlocProvider(
        create: (context) => babyWeightBloc,
        child: BlocListener<BabyWeightBloc, BabyWeightState> (
            listener: (context, state) {
              if (state is LoadingBabyWeightSuccessful) {
                setState(() {
                });
              }

              if (state is SaveBabyWeightSuccessfulState) {
                context.pop();
              }
            },
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/pregnancy_backgroound_3.jpg'),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _weightWidget(),
                      const SizedBox(height: 30),
                      _saveButton()
                    ],
                  )
              ),
            )
        )
    );
  }

  Widget _weightWidget() {
    return Row(
      children: [
        Expanded(
            child: Container()
        ),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.mainColor, width: 1)
          ),
          child: CustomButton(
            titleColor: Colors.black,
            horizontalPadding: 0,
            titleAlignment: Alignment.center,
            title: '-100',
            onTappedAction: () async {
              // Save new aby kick
              babyWeightBloc.add(const EditWeightEvent(-100));
            },
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.mainColor, width: 1)
          ),
          child: CustomButton(
            titleColor: Colors.black,
            horizontalPadding: 0,
            titleAlignment: Alignment.center,
            title: '-1',
            onTappedAction: () async {
              // Save new aby kick
              babyWeightBloc.add(const EditWeightEvent(-1));
            },
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(80)),
              border: Border.all(color: AppColors.mainColor, width: 1)
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${babyWeightBloc.currentBabyWeight.value}').w600().text20().mainColor(),
              const SizedBox(height: 6),
              const Text('gram').w400().text16().blackColor()
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.mainColor, width: 1)
          ),
          child: CustomButton(
            titleColor: Colors.black,
            horizontalPadding: 0,
            titleAlignment: Alignment.center,
            title: '+1',
            onTappedAction: () async {
              // Save new aby kick
              babyWeightBloc.add(const EditWeightEvent(1));
            },
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: AppColors.mainColor, width: 1)
          ),
          child: CustomButton(
            titleColor: Colors.black,
            horizontalPadding: 0,
            titleAlignment: Alignment.center,
            title: '+100',
            onTappedAction: () async {
              // Save new aby kick
              babyWeightBloc.add(const EditWeightEvent(100));
            },
          ),
        ),
        Expanded(
            child: Container()
        ),
      ],
    );
  }

  Widget _saveButton() {
    return CustomButton(
      backgroundColor: AppColors.mainColor,
      titleColor: Colors.white,
      horizontalPadding: 0,
      titleAlignment: Alignment.center,
      title: 'Lưu',
      onTappedAction: () async {
        // Save new aby kick
        babyWeightBloc.add(const SaveBabyWeightEvent());
      },
    );
  }

  void _showDatePicker() async {
    DateTime currentTime = babyWeightBloc.currentBabyWeight.time;
    final date = await showDatePicker2(
      context: context,
      initialDate: currentTime,
      firstDate: DateTime(DateTime.now().year - 1),
      currentDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
      cancelText: 'Huỷ',
      confirmText: 'Xong',
    );
    babyWeightBloc.add(EditTimeEvent(date ?? DateTime.now()));
  }
}
