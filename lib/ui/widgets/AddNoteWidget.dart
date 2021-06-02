import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:life_app/cubits/CubitNote.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/utils/DateHelper.dart';

class AddNoteWidget extends StatelessWidget {
  int activitityId;
  CubitNote cubitNote;
  ScrollController controller;

  AddNoteWidget(this.activitityId, this.cubitNote, this.controller, {Key key}) : super(key: key);
  var noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              scrollDirection: Axis.vertical,
              child: TextField(
                controller: noteController,
                maxLines: 1,
                keyboardType: TextInputType.multiline,
                decoration: new InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    enabledBorder: new OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(40.0),
                      ),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 0.0),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(40.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Type in your text",
                    fillColor: Colors.white70),
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            backgroundColor: AppColors.themeColor,
            onPressed: () {
              addNote(noteController.text,activitityId);
              noteController.text="";

            },
          ),
          SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }

  void addNote(String note, int IdActvity) async {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String createdDate = await DateHelper().getFormatedDateTime(
        dateFormat.parse(dateFormat.format(DateTime.now())));
    String dueDate = await DateHelper().getFormatedDateTime(
        dateFormat.parse(dateFormat.format(DateTime.now())));

    Map<String, dynamic> maps = {
      DatabaseHelper.note_name: note,
      DatabaseHelper.note_created_date: createdDate,
      DatabaseHelper.note_due_date: dueDate,
      DatabaseHelper.note_timeStamp: timeStamp,
      DatabaseHelper.activity_id: IdActvity
    };
    var id = await cubitNote.addNote(maps);
    if (id > 0) {
      cubitNote.fetchNote(IdActvity);
    }
  }
}
