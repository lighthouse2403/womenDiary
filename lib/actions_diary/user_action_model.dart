class UserAction {
   String emoji = '';
   String title = '';
   String note = '';
   DateTime time = DateTime.now();

  UserAction({this.emoji, this.title, this.time});

  UserAction.init(String title, DateTime time, String emoji) {
    this.emoji = emoji;
    title = title;
    note = '';
    time = DateTime.now();
  }

  UserAction.fromDatabase(Map<String, dynamic> json) {
    emoji = json['emoji'];
    title = json['title'];
    note = json['note'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['emoji'] = emoji;
    data['title'] = title;
    data['note'] = note;
    data['time'] = time.millisecondsSinceEpoch;
    return data;
  }
}