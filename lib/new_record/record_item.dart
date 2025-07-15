
import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:flutter/material.dart';

class NewRecordItem extends StatefulWidget {
  const NewRecordItem({super.key, required this.type});

  final ActionType type;

  @override
  State<StatefulWidget> createState() =>
      _NewRecordItemState();
}

class _NewRecordItemState extends State<NewRecordItem> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (widget.type) {
          case ActionType.eating:
            break;
          case ActionType.bottleMilk:
            break;
          case ActionType.motherMilk:
            break;
          case ActionType.peePoo:
            break;
          case ActionType.pee:
            break;
          case ActionType.poo:
            break;
          case ActionType.sleep:
            break;
          case ActionType.bath:
            break;
          case ActionType.temperature:
            break;
          case ActionType.vaccination:
            break;
        }
      },
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withAlpha(200),
                spreadRadius: 3,
                blurRadius: 7,
                offset: const Offset(2, 3),
              ),
            ],
          ),
          child: Image.asset(
            'assets/new_record_icon/${widget.type.label}.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
