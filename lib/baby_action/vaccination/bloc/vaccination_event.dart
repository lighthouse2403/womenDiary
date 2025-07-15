import 'package:baby_diary/baby_action/vaccination/vaccination_model.dart';
import 'package:equatable/equatable.dart';

abstract class VaccinationEvent extends Equatable {
  const VaccinationEvent();
}

class LoadVaccinationEvent extends VaccinationEvent {
  const LoadVaccinationEvent();

  @override
  List<Object?> get props => [];
}

class RefreshVaccinationEvent extends VaccinationEvent {
  const RefreshVaccinationEvent();

  @override
  List<Object?> get props => [];
}

class UpdateRatingEvent extends VaccinationEvent {
  final VaccinationModel vaccination;
  final int rating;
  const UpdateRatingEvent(this.rating, this.vaccination);

  @override
  List<Object?> get props => [rating, vaccination];
}

class UpdateNumberOfViewEvent extends VaccinationEvent {
  final VaccinationModel vaccination;
  const UpdateNumberOfViewEvent(this.vaccination);

  @override
  List<Object?> get props => [vaccination];
}

class SearchVaccinationByLocation extends VaccinationEvent {
  final String location;
  const SearchVaccinationByLocation(this.location);

  @override
  List<Object?> get props => [location];
}

class SearchVaccinationByString extends VaccinationEvent {
  final String text;
  const SearchVaccinationByString(this.text);

  @override
  List<Object?> get props => [text];
}
