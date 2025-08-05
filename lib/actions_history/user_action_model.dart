import 'package:women_diary/actions_history/new_action.dart';

class UserAction {
   String id = '${DateTime.now().millisecondsSinceEpoch}';
   String emoji = '';
   String title = '';
   String note = '';
   ActionType type = ActionType.stomachache;
   DateTime time = DateTime.now();

  UserAction({
    required this.id,
    required this.emoji,
    required this.time
  });

  UserAction.init(String title, DateTime time, String emoji, String note) {
    this.id = '${DateTime.now().millisecondsSinceEpoch}';
    this.emoji  = emoji;
    this.title  = title;
    this.note   = note;
    this.time   = time;
    this.type   = ActionType.stomachache;
  }

  UserAction.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    emoji = json['emoji'];
    title = json['title'];
    note = json['note'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    type = (json['time'] as int).toActionType();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['emoji'] = emoji;
    data['title'] = title;
    data['note'] = note;
    data['time'] = time.millisecondsSinceEpoch;
    data['type'] = type.index;
    return data;
  }
}