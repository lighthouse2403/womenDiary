import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:women_diary/actions_history/action_type.dart';
import 'package:women_diary/actions_history/bloc/action_bloc.dart';
import 'package:women_diary/actions_history/bloc/action_event.dart';
import 'package:women_diary/actions_history/bloc/action_state.dart';

class FilterChips extends StatelessWidget {
  const FilterChips();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActionBloc, ActionState>(
      buildWhen: (pre,cur) => cur is ActionTypeUpdatedState,
      builder: (context, state) {
        ActionType? selectedType = state is ActionTypeUpdatedState ? state.type : null;
        print('selectedType ${selectedType}');
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Wrap(
            spacing: 8,
            children: [
              _chip(
                context,
                label: "Tất cả",
                selected: selectedType == null,
                onTap: () =>
                    context.read<ActionBloc>().add(UpdateActionTypeEvent(null)),
              ),
              ...ActionType.values.map((type) => _chip(
                context,
                label: type.display,
                selected: selectedType == type,
                onTap: () => context
                    .read<ActionBloc>()
                    .add(UpdateActionTypeEvent(type)),
              )),
            ],
          ),
        );
      },
    );
  }

  Widget _chip(BuildContext context,
      {required String label,
        required bool selected,
        required VoidCallback onTap}) {
    return ChoiceChip(
      label: Text(label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      selected: selected,
      selectedColor: Colors.pink.shade100,
      backgroundColor: Colors.grey.shade100,
      labelStyle: TextStyle(
        color: selected ? Colors.pink.shade700 : Colors.black87,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? Colors.pink.shade200 : Colors.grey.shade300,
        ),
      ),
      visualDensity: VisualDensity.compact,
      onSelected: (_) => onTap(),
    );
  }
}