import 'package:life_app/database/DatabaseHelper.dart';

class NoteModel {
  int note_id, activity_id, note_timeStamp;
  String note_name, note_created_date, note_due_date;

  NoteModel(
      {this.note_id,
      this.activity_id,
      this.note_timeStamp,
      this.note_name,
      this.note_created_date,
      this.note_due_date});

}
