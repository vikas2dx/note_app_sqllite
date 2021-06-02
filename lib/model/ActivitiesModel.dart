import 'package:life_app/database/DatabaseHelper.dart';

class ActivitiesModel {
  int column_id, timeStamp;
  String activity_name, created_date, due_date,description;

  ActivitiesModel({this.column_id, this.timeStamp, this.activity_name,
      this.created_date, this.due_date,this.description});
}
