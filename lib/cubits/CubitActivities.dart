import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_app/cubits/CubitState.dart';
import 'package:life_app/cubits/UiCubit.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/model/ActivitiesModel.dart';

class CubitActivities extends Cubit<CubitState> {
  DatabaseHelper dbHelper;
  UICubit<bool> loaderCubit = UICubit<bool>(false);
  List<ActivitiesModel> activitiesList;

  CubitActivities() : super(InitialState());

  void addActivities(Map<String, dynamic> row, BuildContext context) async {
    loaderCubit.updateState(true);
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    var id = await dbHelper.insert(row);
    print("Inserted id $id");

    loaderCubit.updateState(false);
    Navigator.pop(context, id);
  }

  void updateActivities(
      Map<String, dynamic> row, BuildContext context, String ActivityId) async {
    loaderCubit.updateState(true);
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    var id = await dbHelper.updateActivities(row, ActivityId);
    print("Updated id $id");

    loaderCubit.updateState(false);
    Navigator.pop(context, id);
  }

  void fetchActivities() async {
    emit(LoadingState());
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    activitiesList = await dbHelper.fetchActivities();
    if (activitiesList.isEmpty) {
      emit(FailedState());
    } else {
      emit(SuccessState());
    }
  }

  Future<int> renameActivities(
      Map<String, dynamic> maps, String activitityID) async {
    if (dbHelper == null) {
      dbHelper = DatabaseHelper.instance;
    }
    int updateStatus = await dbHelper.renameActivity(maps, activitityID);
    print("Update Status $updateStatus");
    if (updateStatus > 0) {
      emit(SuccessState(message: "Rename Successfully"));
    } else {
      emit(FailedState(message: "Failed to Rename"));
    }
    return updateStatus;
  }
}
