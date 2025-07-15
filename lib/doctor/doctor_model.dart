
class DoctorModel {
  String doctorId = '';
  String name = '';
  String? address = '';
  String? time = '';
  String? hospital = '';
  String? phone = '';
  String? description = '';
  List<int>? rate = [];
  int? view = 0;

  DoctorModel({
    required this.doctorId,
    required this.name,
    this.address,
    this.time,
    this.hospital,
    this.rate,
    this.view,
    this.phone,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    time = json['time']?? '';
    hospital = json['hospital'] ?? '';
    phone = json['phone'] ?? '';
    description = json['description'] ?? '';
    if (json['rate'] != null) {
      rate = List.from(json['rate']);
    }
    view = json['view'] ?? 0;
  }

  DoctorModel.fromDatabase(Map<String, dynamic> json) {
    doctorId = json['doctorId'] ?? '';
    name = json['name'] ?? '';
    address = json['address'] ?? '';
    time = json['time']?? '';
    hospital = json['hospital'] ?? '';
    phone = json['phone'] ?? '';
    description = json['description'] ?? '';
    view = json['view'] ?? 0;

    String rates = json['rate'] ?? '';
    if (rates.isEmpty) {
      return;
    }

    if (rates.contains('--')) {
      List<String> ratesString = rates.split('--');
      rate = ratesString.map((e) => int.parse(e)).toList();
    } else {
      rate = [int.parse(rates ?? '')];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['name'] = name;
    data['address'] = address;
    data['time'] = time;
    data['hospital'] = hospital;
    data['description'] = description;
    data['view'] = view;

    int firstRate = rate?.firstOrNull ?? 0;
    List<int> rates = rate ?? [];
    if (rates.length > 1) {
      data['rate'] = rates.join('--');
    } else {
      data['rate'] = '$firstRate';
    }
    return data;
  }
}