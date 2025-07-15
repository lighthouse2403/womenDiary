import 'package:baby_diary/baby_action/eating/bloc/eating_bloc.dart';
import 'package:baby_diary/baby_action/eating/bloc/eating_event.dart';
import 'package:baby_diary/baby_action/eating/bloc/eating_state.dart';
import 'package:baby_diary/common/constants/constants.dart';
import 'package:baby_diary/common/widgets/number_text_field.dart';
import 'package:baby_diary/routes/route_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/constants/app_colors.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class NewEating extends StatelessWidget {
  const NewEating({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EatingBloc()..add(const InitEatingDetailEvent(null)),
      child: const _NewEatingView(),
    );
  }
}

class _NewEatingView extends StatefulWidget {
  const _NewEatingView();

  @override
  State<_NewEatingView> createState() => _NewEatingViewState();
}

class _NewEatingViewState extends State<_NewEatingView> {
  TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EatingBloc, EatingState>(
      listener: (context, state) {
        if (state is SaveEatingSuccessfulState) {
          Fluttertoast.showToast(
              msg: 'Đã lưu thành công',
              gravity: ToastGravity.CENTER
          ).whenComplete(() {});
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(context),
          body: _buildBody(context),
        );
      },
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('').w500().text16().whiteColor(),
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () {

        },
        child: Align(
          alignment: Alignment.center,
          child: Assets.icons.arrowBack.svg(
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn)
          ),
        ),
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: _backgroundDecoration(),
      child: SafeArea(
        child: Column(
          children: [
            _selectedBaby(),
            const SizedBox(height: 40),
            _quantityInput(),
            const SizedBox(height: 40),
            _saveButton(),
          ],
        ),
      ),
    );
  }

  Widget _selectedBaby() {
    return BlocBuilder<EatingBloc, EatingState>(
      buildWhen: (previous, current) => current is ChangedBabyState,
      builder: (context, state) {
        final babyName = (state is ChangedBabyState) ? state.selectedBaby.babyName : '';
        return _customButton(
            title: babyName,
            onTap: _navigateAndUpdate,
            textColor: AppColors.pinkTextColor,
            size: 20
        );
      },
    );
  }

  Widget _quantityInput() {
    return Row(
      children: [
        Text('Lượng thức ăn').w500().text14().primaryTextColor(),
        Constants.vSpacer8,
        Expanded(
          child: NumericTextField(
            onTextChanged: (value) {
              context.read<EatingBloc>().add(ChangedQuantityEvent(int.tryParse(value) ?? 0));
            },
          ),
        ),
      ],
    );
  }

  void _navigateAndUpdate() async {
    await Navigator.of(context).pushNamed(RoutesName.babySelection).then((value) {
      // context.read<EatingBloc>().add(ChangeSelectedBabyEvent());
    });
  }

  Widget _saveButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: _customButton(
                title: 'Đếm lại',
                color: AppColors.mainColor,
                onTap: () => context.read<EatingBloc>().add(const CreateNewEatingEvent())
            )
        ),
        const SizedBox(width: 30),
        Expanded(
            child: _customButton(
                title: 'Lưu',
                color: AppColors.mainColor,
                onTap: () => context.read<EatingBloc>().add(const CreateNewEatingEvent())
            )
        ),
      ],
    );
  }

  Widget _customButton({
    required String title,
    Color color = Colors.white,
    Color textColor = Colors.white,
    double size = 14,
    VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: color.withAlpha(180)),
        child: Center(child: Text(title).w500().ellipsis().customColor(textColor).customSize(size)),
      ),
    );
  }

  Widget _buildCircleButton(String title, Widget icon) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(color: Colors.white.withAlpha(200), shape: BoxShape.circle),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, const SizedBox(height: 10), Text(title).w500().text20().mainColor()],
      ),
    );
  }

  BoxDecoration _backgroundDecoration() {
    return const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/pregnancy_background_3.jpg'), fit: BoxFit.cover));
  }
}
