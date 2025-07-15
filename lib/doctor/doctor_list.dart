import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:women_diary/common/base/base_statefull_widget.dart';
import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/constants/constants.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:women_diary/common/firebase/firebase_doctor.dart';
import 'package:women_diary/common/widgets/action_sheet/bottom_sheet_action.dart';
import 'package:women_diary/common/widgets/action_sheet/bottom_sheet_alert.dart';
import 'package:women_diary/common/widgets/action_sheet/cancel_action.dart';
import 'package:women_diary/common/widgets/customTextField.dart';
import 'package:women_diary/doctor/bloc/doctor_bloc.dart';
import 'package:women_diary/doctor/bloc/doctor_event.dart';
import 'package:women_diary/doctor/bloc/doctor_state.dart';
import 'package:women_diary/doctor/child_widget/doctor_row.dart';
import 'package:women_diary/doctor/doctor_model.dart';
import 'package:women_diary/routes/routes.dart';
import 'package:go_router/go_router.dart';

class Doctor extends BaseStatefulWidget {
  const Doctor({super.key});
  @override
  State<Doctor> createState() => _DoctorState();
}

class _DoctorState extends BaseStatefulState<Doctor> {
  final ScrollController _controller = ScrollController();
  final double _endReachedThreshold = 30;
  bool _loading = false;
  DoctorBloc doctorBloc = DoctorBloc();
  final TextEditingController _textController = TextEditingController();
  Timer? _bounceTimer;

  @override
  void dispose() {
    _textController.dispose();
    _bounceTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScroll);
    doctorBloc.add(const LoadDoctor());
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final shouldReload = _controller.position.extentAfter < _endReachedThreshold;
    bool isNotFull = doctorBloc.doctors.length >= FirebaseDoctor.instance.limit;
    if (shouldReload && !_loading && isNotFull) {
      _loading = true;
      doctorBloc.add(const LoadDoctor());
    }
  }

  @override
  PreferredSizeWidget? buildAppBar() {
    List<BottomSheetAction> locationActionSheet = [];

    for (var value in Constants.locations) {
      locationActionSheet.add(_searchDoctors(value));
    }
    return AppBar(
      backgroundColor: AppColors.mainColor,
      title: InkWell(
        onTap: () async {
          showAdaptiveActionSheet(
            context: context,
            actions: locationActionSheet,
            cancelAction: CancelAction(
                title: const Text('Huỷ').text14().w400().redColor()
            ),
          );
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(doctorBloc.location).w500().text16().whiteColor(),
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
      )
    );
  }

  @override
  Widget? buildBody() {
    return BlocProvider(
        create: (context) => doctorBloc,
        child: BlocListener<DoctorBloc, DoctorState> (
            listener: (context, state) {
              if (state is LoadingState) {
                loadingView.show(context);
                return;
              }

              if (state is LoadingSuccessfulState) {
                setState(() {
                  _loading = false;
                });
                loadingView.hide();
              }
            },
            child: CustomScrollView(
              controller: _controller,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                CupertinoSliverRefreshControl(
                  onRefresh: _refresh,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 5,
                  )
                ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    height: 60,
                    child: CustomTextField(
                      hintText: 'Tìm kiếm',
                      maxLines: 1,
                      controller: _textController,
                      enable: true,
                      onTextChanged: (value) {
                        _onTextChanged(value);
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    DoctorModel doctor = doctorBloc.currentDoctors[index];
                    return InkWell(
                      onTap: () {
                        // Routes.instance.navigateTo(RoutesName.doctorDetail, arguments: doctor);
                      },
                      child: DoctorRow(doctor: doctor),
                    );
                  },
                    childCount: doctorBloc.currentDoctors.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: 30,
                      child: FirebaseDoctor.instance.limit > doctorBloc.doctors.length
                          ? Container()
                          : const CupertinoActivityIndicator(radius: 12.0, color: CupertinoColors.inactiveGray)
                  ),
                )
              ],
            )
        )
    );
  }

  Future<void> _refresh() async {
    doctorBloc.add(const RefreshDoctor());
  }

  BottomSheetAction _searchDoctors(String title) {
    return BottomSheetAction(
      title: Text(title).text14().w400().blackColor(),
      onPressed: (_) async {
        print(title);
        doctorBloc.add(SearchDoctorsByLocation(title));
      },
    );
  }

  void _onTextChanged(String text) {
    if (_bounceTimer != null && _bounceTimer!.isActive) {
      _bounceTimer!.cancel();
    }
    _bounceTimer = Timer(const Duration(milliseconds: 700), () {
      doctorBloc.add(SearchDoctorsByString(text));
    });
  }
}
