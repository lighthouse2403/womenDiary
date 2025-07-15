import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/baby_information/bloc/baby_bloc.dart';
import 'package:baby_diary/baby_information/bloc/baby_event.dart';
import 'package:baby_diary/baby_information/bloc/baby_state.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/common/widgets/dob_picker.dart';
import 'package:baby_diary/common/widgets/input_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:baby_diary/common/base/base_app_bar.dart';

class BabyDetail extends StatelessWidget {
  const BabyDetail({super.key, required this.baby});
  final BabyModel baby;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => BabyBloc()..add(InitBabyDetailEvent(baby)),
        child: const _BabyDetailView()
    );
  }
}

class _BabyDetailView extends StatefulWidget {
  const _BabyDetailView();

  @override
  State<_BabyDetailView> createState() => _BabyDetailViewState();
}

class _BabyDetailViewState extends State<_BabyDetailView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: 'aaaa', hasBack:  true),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _name(),
                    _dob(),
                    _gender(),
                    _standWeight(),
                    _standHeight(),
                    _saveButton()
                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }

  Widget _name() {
    return InputRow(
      title: 'Full Name',
      hintText: 'Input name',
      onTextChanged: (name) => context.read<BabyBloc>().add(
        UpdatedNameEvent(name),
      ),
    );
  }

  Widget _dob() {
    return BlocBuilder<BabyBloc, BabyState>(
      buildWhen: (context, state) => state is UpdatedDobState,
      builder: (context, state) {
        DateTime dob = state is UpdatedDobState ? state.dob : DateTime.now();
        return DobPicker(
          selectedDob: dob,
          onDobChanged: (date) => context.read<BabyBloc>().add(
            UpdatedDobEvent(date),
          ),
        );
      },
    );
  }

  Widget _gender() {
    return BlocBuilder<BabyBloc, BabyState>(
      buildWhen: (context, state) => state is UpdatedGenderState,
      builder: (context, state) {
        Gender selectedGender = state is UpdatedGenderState ? state.gender : Gender.male;
        return Row(
          children: [
            Text('Gender').text14().w400().mainColor(),
            Expanded(child: Container()),
            CupertinoSegmentedControl<String>(
              children: {
                Gender.male.label: Padding(padding: EdgeInsets.all(8), child: Text('Male')),
                Gender.female.label: Padding(padding: EdgeInsets.all(8), child: Text('Female')),
              },
              groupValue: selectedGender.label,
              onValueChanged: (String value) {
                context.read<BabyBloc>().add(UpdatedGenderEvent(GenderExtension.fromLabel(value) ?? Gender.male));
              },
            )
          ],
        );
      },
    );
  }

  Widget _standWeight() {
    return Row(
      children: [
        Text('Standard Weight:').text14().w400().mainColor(),
        Expanded(
            child: Container(
              alignment: Alignment.centerRight,
              child: Text('1288-2200 (gram)').text14().w400().mainColor(),
            )
        )
      ],
    );
  }

  Widget _standHeight() {
    return SizedBox(
      child: Row(
        children: [
          Text('Standard Height:').text14().w400().mainColor(),
          Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                child: Text('76-82 (cm)').text14().w400().mainColor(),
              )
          )
        ],
      ),
    );
  }

  Widget _saveButton() {
    return TextButton(
      child: const Text('Save'),
      onPressed: () =>  context.read<BabyBloc>().add(const SaveBabyDetailEvent()
    ));
  }
}