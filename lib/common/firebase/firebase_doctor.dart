import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:women_diary/doctor/doctor_model.dart';

class FirebaseDoctor {
  FirebaseDoctor._();

  static final instance = FirebaseDoctor._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  int limit = 300;

  Future<void> addDoctor(String name, String address, String? hospital, String time) async {
    CollectionReference doctor = firestore.collection('doctors');
    doctor.add({
        'name': name,
        'address': address,
        'hospital': hospital ?? '',
        'time': time,
      }).then((value) => print("User Doctor"))
          .catchError((error) => print("Failed to add Doctor: $error"));
  }

  Future<List<DoctorModel>> loadDoctors() async {
    limit += 50;
    QuerySnapshot chatSnapshot = await firestore.collection('doctors').limit(limit).get();

    final allData = chatSnapshot.docs.map((doc) {
      return DoctorModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
    return allData;
  }

  Future<void> updateRating(DoctorModel doctor, int rating) async {
    CollectionReference chat = firestore.collection('doctors');
    List<int> newRating = doctor.rate ?? [];
    newRating.add(rating);

    await chat.doc(doctor.doctorId).update({
      'rate' : newRating
    });
  }

  Future<void> updateView(DoctorModel doctor) async {
    CollectionReference chat = firestore.collection('doctors');
    int newViews = doctor.view ?? 0;

    await chat.doc(doctor.doctorId).update({
      'view' : newViews + 1
    });
  }
}