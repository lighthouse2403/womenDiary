import 'package:baby_diary/baby_action/vaccination/vaccination_model.dart';
import 'package:flutter/material.dart';
import 'package:baby_diary/_gen/assets.gen.dart';
import 'package:baby_diary/common/extension/text_extension.dart';

class VaccinationRow extends StatefulWidget {
  const VaccinationRow({super.key, required this.vaccination});

  final VaccinationModel vaccination;

  @override
  State<VaccinationRow> createState() => VaccinationRowState();
}

class VaccinationRowState extends State<VaccinationRow> {

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
              color: Colors.grey.withAlpha(120),
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
          Text(widget.vaccination.name).w600().text15().mainColor().ellipsis(),
          const SizedBox(height: 6),
          Row(
            children: [
              Assets.icons.address.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(widget.vaccination.address).w400().text14()
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Assets.icons.phone.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text('${widget.vaccination.phone}').w400().text14().customColor(Colors.blue).ellipsis()
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Assets.icons.time.svg(width: 16, height: 16),
              const SizedBox(width: 6),
              Expanded(
                  child: Text('${widget.vaccination.time}').w400().text14()
              )
            ],
          )
        ],
      ),
    );
  }
}
