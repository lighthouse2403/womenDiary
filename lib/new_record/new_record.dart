import 'package:baby_diary/baby_action/baby_action_model.dart';
import 'package:baby_diary/new_record/record_item.dart';
import 'package:flutter/material.dart';

class NewRecord extends StatelessWidget {
  NewRecord({super.key});

  final List<ActionType> types = [
    ActionType.bath,
    ActionType.eating,
    ActionType.bottleMilk,
    ActionType.motherMilk,
    ActionType.peePoo,
    ActionType.pee,
    ActionType.poo,
    ActionType.sleep,
    ActionType.temperature,
    ActionType.vaccination
  ];

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: Container(
            height: 20,
          ),
        ),
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 20.0,
              crossAxisSpacing: 20.0),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return NewRecordItem(type: types[index]);
            },
            childCount: types.length,
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            height: 20,
          ),
        )
      ],
    );
  }
}

