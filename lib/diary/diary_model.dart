
class DiaryModel {
  String id = '${DateTime.now().millisecondsSinceEpoch}';
  String content = '';
  List<String> url = [];
  DateTime time = DateTime.now();
  DateTime birthDate = DateTime.now();
  DateTime createdTime = DateTime.now();
  DateTime updatedTime = DateTime.now();

  DiaryModel({
    required this.id,
    required this.content,
    required this.birthDate,
    required this.createdTime,
    required this.updatedTime,
  });

  DiaryModel.init() {
    id = '${DateTime.now().millisecondsSinceEpoch}';
    content = '';
    url = [];
    time = DateTime.now();
    birthDate = DateTime.now();
    createdTime = DateTime.now();
    updatedTime = DateTime.now();
  }

  DiaryModel.fromDatabase(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    time = DateTime.fromMillisecondsSinceEpoch(json['time'] as int);
    birthDate = DateTime.fromMillisecondsSinceEpoch(json['birthDate'] as int);
    createdTime = DateTime.fromMillisecondsSinceEpoch(json['createdTime'] as int);
    updatedTime = DateTime.fromMillisecondsSinceEpoch(json['updatedTime'] as int);

    String mediaURL = json['url'] ?? '';
    if (mediaURL.isEmpty) {
      return;
    }

    if (mediaURL.contains('--')) {
      url = json['url'].split('--');
    } else {
      url = [json['url']];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['diaryId'] = id;
    data['content'] = content;
    data['time'] = time.millisecondsSinceEpoch;
    data['birthDate'] = birthDate.millisecondsSinceEpoch;
    data['createdTime'] = createdTime.millisecondsSinceEpoch;
    data['updatedTime'] = updatedTime.millisecondsSinceEpoch;

    String media = url.firstOrNull ?? '';

    if (url.length > 1) {
      media = url.join('--');
    }
    data['url'] = media;
    return data;
  }
}