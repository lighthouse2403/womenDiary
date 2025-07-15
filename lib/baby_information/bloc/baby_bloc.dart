import 'package:baby_diary/baby_information/baby_model.dart';
import 'package:baby_diary/baby_information/bloc/baby_event.dart';
import 'package:baby_diary/baby_information/bloc/baby_state.dart';
import 'package:baby_diary/database/data_handler.dart';
import 'package:bloc/src/bloc.dart';

class BabyBloc extends Bloc<BabyEvent, BabyState> {
  List<BabyModel> babies =[];
  BabyModel baby = BabyModel.init();

  BabyBloc() : super(const BabyState()) {
    on<UpdatedNameEvent>(_nameChanged);
    on<UpdatedDobEvent>(_dobChanged);
    on<UpdatedGenderEvent>(_genderChanged);
    on<InitBabyDetailEvent>(_addBabyDetail);
    on<LoadAllBabyEvent>(_loadALlABaby);
    on<DeleteBabyEvent>(_deleteBaby);
    on<SelectedBabyEvent>(_selectedBaby);
    on<SaveBabyDetailEvent>(_saveBabyDetail);
  }

  Future<void> _addBabyDetail(InitBabyDetailEvent event, Emitter emit) async {
    baby = event.baby;
    emit(AddedBabyDetailState(baby));
  }

  Future<void> _loadALlABaby(LoadAllBabyEvent event, Emitter emit) async {
    babies = await DatabaseHandler.getAllBaby();
    emit(LoadedBabiesState(babies));
  }

  void _nameChanged(UpdatedNameEvent event, Emitter emit) async {
    baby.babyName = event.name;
  }

  void _dobChanged(UpdatedDobEvent event, Emitter emit) async {
    baby.birthDate = event.dob;
    emit(UpdatedDobState(event.dob));
  }

  void _genderChanged(UpdatedGenderEvent event, Emitter emit) async {
    baby.gender = event.gender;
    emit(UpdatedGenderState(event.gender));
  }

  void _deleteBaby(DeleteBabyEvent event, Emitter emit) async {
    await DatabaseHandler.deleteBaby(event.baby.babyId);
    babies.removeWhere((e) => e.babyId == event.baby.babyId);
    emit(LoadedBabiesState(babies));
  }

  void _selectedBaby(SelectedBabyEvent event, Emitter emit) async {
    BabyModel newBaby = event.newBaby;
    newBaby.selected = 1;
    await DatabaseHandler.updateBaby(newBaby);
  }

  void _saveBabyDetail(SaveBabyDetailEvent event, Emitter emit) async {
    await DatabaseHandler.updateBaby(baby);
  }
}
