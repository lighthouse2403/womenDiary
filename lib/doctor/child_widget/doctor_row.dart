import 'package:flutter/material.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/extension/text_extension.dart';
import 'package:baby_diary/doctor/doctor_model.dart';

class DoctorRow extends StatefulWidget {
  const DoctorRow({super.key, required this.doctor});

  final DoctorModel doctor;

  @override
  State<DoctorRow> createState() => DoctorRowState();
}

class DoctorRowState extends State<DoctorRow> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.doctor.name).w600().text15().mainColor(),
          const SizedBox(height: 6),
          Row(
            children: [
              Assets.icons.address.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text('${widget.doctor.address}').w400().text14()
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Assets.icons.phone.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text('${widget.doctor.phone}').w400().text14().customColor(Colors.blue)
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Assets.icons.time.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text('${widget.doctor.time}').w400().text14()
              )
            ],
          )
        ],
      ),
    );
  }
}
