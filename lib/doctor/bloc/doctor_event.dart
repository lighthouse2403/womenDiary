import 'package:equatable/equatable.dart';
import 'package:baby_diary/doctor/doctor_model.dart';

abstract class DoctorEvent extends Equatable {
  const DoctorEvent();
}

class LoadDoctor extends DoctorEvent {
  const LoadDoctor();

  @override
  List<Object?> get props => [];
}

class RefreshDoctor extends DoctorEvent {
  const RefreshDoctor();

  @override
  List<Object?> get props => [];
}

class UpdateRatingEvent extends DoctorEvent {
  final DoctorModel doctor;
  final int rating;
  const UpdateRatingEvent(this.rating, this.doctor);

  @override
  List<Object?> get props => [rating, doctor];
}

class UpdateNumberOfViewEvent extends DoctorEvent {
  final DoctorModel doctor;
  const UpdateNumberOfViewEvent(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

class SearchDoctorsByLocation extends DoctorEvent {
  final String location;
  const SearchDoctorsByLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class SearchDoctorsByString extends DoctorEvent {
  final String text;
  const SearchDoctorsByString(this.text);

  @override
  List<Object?> get props => [text];
}
