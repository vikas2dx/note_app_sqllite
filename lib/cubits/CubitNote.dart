import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_app/cubits/CubitState.dart';
import 'package:life_app/cubits/UiCubit.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/model/NoteModel.dart';

class CubitNote extends Cubit<CubitState> {
  UICubit<bool> loader = UICubit<bool>(false);
  DatabaseHelper databaseHelper;
  List<NoteModel> noteList;

  CubitNote() : super(InitialState());

  Future<int> addNote(Map<String, dynamic> row) async {
    loader.updateState(true);
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    var id = await databaseHelper.addNote(row);
    print("Add note $id");
    loader.updateState(false);
    return id;
  }

  Future<List<NoteModel>> fetchNote(int activityId) async {
    emit(LoadingState());
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper.instance;
    }
    noteList = await databaseHelper.fetchNote(activityId);
    if (noteList.isEmpty) {
      emit(FailedState());
    } else {
      emit(SuccessState());
    }
    return noteList;
  }

}
