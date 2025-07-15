import 'dart:async';
import 'package:baby_diary/baby_action/vaccination/bloc/vaccination_bloc.dart';
import 'package:baby_diary/baby_action/vaccination/bloc/vaccination_event.dart';
import 'package:baby_diary/baby_action/vaccination/bloc/vaccination_state.dart';
import 'package:baby_diary/baby_action/vaccination/child_widget/vaccination_row.dart';
import 'package:baby_diary/baby_action/vaccination/vaccination_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/common/firebase/firebase_vaccination.dart';
import 'package:baby_diary/common/widgets/action_sheet/bottom_sheet_action.dart';
import 'package:baby_diary/common/widgets/action_sheet/bottom_sheet_alert.dart';
import 'package:baby_diary/common/widgets/action_sheet/cancel_action.dart';
import 'package:baby_diary/common/widgets/customTextField.dart';
import 'package:baby_diary/routes/routes.dart';

class Vaccination extends BaseStatefulWidget {
  const Vaccination({super.key});
  @override
  State<Vaccination> createState() => _VaccinationState();
}

class _VaccinationState extends BaseStatefulState<Vaccination> {
  final ScrollController _controller = ScrollController();
  final double _endReachedThreshold = 30;
  bool _loading = false;
  VaccinationBloc vaccinationBloc = VaccinationBloc();
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
    vaccinationBloc.add(const LoadVaccinationEvent());
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading) return;

    final shouldReload = _controller.position.extentAfter < _endReachedThreshold;
    bool isNotFull = vaccinationBloc.vaccinations.length >= FirebaseVaccination.instance.limit;
    if (shouldReload && !_loading && isNotFull) {
      _loading = true;
      vaccinationBloc.add(const LoadVaccinationEvent());
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
              Text(vaccinationBloc.location).w500().text16().whiteColor(),
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
          onTap: () {

          },
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
        create: (context) => vaccinationBloc,
        child: BlocListener<VaccinationBloc, VaccinationState> (
            listener: (context, state) {
              if (state is LoadingVaccinationState) {
                loadingView.show(context);
                return;
              }

              if (state is LoadingVaccinationSuccessfulState) {
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
                    VaccinationModel vaccination = vaccinationBloc.currentVaccination[index];
                    return InkWell(
                      onTap: () {
                        // Routes.instance.navigateTo(RoutesName.doctorDetail, arguments: doctor);
                      },
                      child: VaccinationRow(vaccination: vaccination),
                    );
                  },
                    childCount: vaccinationBloc.currentVaccination.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                      height: 30,
                      child: FirebaseVaccination.instance.limit > vaccinationBloc.vaccinations.length
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
    vaccinationBloc.add(const RefreshVaccinationEvent());
  }

  BottomSheetAction _searchDoctors(String title) {
    return BottomSheetAction(
      title: Text(title).text14().w400().blackColor(),
      onPressed: (_) async {
        vaccinationBloc.add(SearchVaccinationByLocation(title));
      },
    );
  }

  void _onTextChanged(String text) {
    if (_bounceTimer != null && _bounceTimer!.isActive) {
      _bounceTimer!.cancel();
    }
    _bounceTimer = Timer(const Duration(milliseconds: 700), () {
      vaccinationBloc.add(SearchVaccinationByString(text));
    });
  }
}
