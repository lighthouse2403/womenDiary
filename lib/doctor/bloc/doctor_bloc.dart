import 'package:bloc/bloc.dart';
import 'package:baby_diary/common/firebase/firebase_doctor.dart';
import 'package:baby_diary/doctor/bloc/doctor_event.dart';
import 'package:baby_diary/doctor/bloc/doctor_state.dart';
import 'package:baby_diary/doctor/doctor_model.dart';

class DoctorBloc extends Bloc<DoctorEvent, DoctorState> {
  List<DoctorModel> doctors = [];
  String location = 'Hà Nội';
  List<DoctorModel> currentDoctors = [];

  DoctorBloc() : super(const DoctorState()) {
    on<LoadDoctor>(_loadDoctors);
    on<UpdateRatingEvent>(_updateRating);
    on<UpdateNumberOfViewEvent>(_updateNumberOfView);
    on<SearchDoctorsByLocation>(_searchDoctorsByLocation);
    on<SearchDoctorsByString>(_searchDoctorsByString);

  }

  Future<void> _searchDoctorsByLocation(SearchDoctorsByLocation event, Emitter<DoctorState> emit) async {
    try {
      emit(const LoadingState());
      location = event.location;
      currentDoctors = doctors.where((element) => (element.address ?? '').contains(location)).toList();
      print(currentDoctors);
      emit(const LoadingSuccessfulState());
    } catch (error) {
      emit(const LoadingSuccessfulState());
    }
  }

  Future<void> _searchDoctorsByString(SearchDoctorsByString event, Emitter<DoctorState> emit) async {
    try {
      emit(const LoadingState());
      currentDoctors = doctors.where((element) {
        bool isLocation = (element.address ?? '').toLowerCase().contains(location.toLowerCase());
        bool isSearchAddress = (element.address ?? '').toLowerCase().contains(event.text.toLowerCase());
        bool isSearchName = element.name.toLowerCase().contains(event.text.toLowerCase());

        return (isLocation && isSearchAddress) || (isLocation && isSearchName);
      }).toList();
      emit(const LoadingSuccessfulState());
    } catch (error) {
      emit(const LoadingSuccessfulState());
    }
  }

  Future<void> _loadDoctors(LoadDoctor event, Emitter<DoctorState> emit) async {
    try {
      emit(const LoadingState());
      doctors = await FirebaseDoctor.instance.loadDoctors();
      currentDoctors = doctors;
      emit(const LoadingSuccessfulState());
    } catch (error) {
      emit(const LoadingSuccessfulState());
    }
  }

  Future<void> _updateRating(UpdateRatingEvent event, Emitter<DoctorState> emit) async {
    try {
      emit(const LoadingState());
      await FirebaseDoctor.instance.updateRating(event.doctor, event.rating);
      emit(const UpdateRatingSuccessfulState());
    } catch (error) {
      emit(const UpdateRatingFailState());
    }
  }

  Future<void> _updateNumberOfView(UpdateNumberOfViewEvent event, Emitter<DoctorState> emit) async {
    try {
      emit(const LoadingState());
      await FirebaseDoctor.instance.updateView(event.doctor);
      emit(const UpdateNumberOfViewSuccessfulState());
    } catch (error) {
      emit(const UpdateNumberOfViewFailState());
    }
  }
}
