
class MusicModel {
  String? name = '';
  String path = '';
  bool status = false;

  MusicModel({
    required this.name,
    required this.path,
    required this.status,
  });

  MusicModel.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? '';
    path = json['path']?? '';
    status = json['status'] ?? '';
  }
}