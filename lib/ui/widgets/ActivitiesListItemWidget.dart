import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_app/cubits/CubitActivities.dart';
import 'package:life_app/cubits/CubitNote.dart';
import 'package:life_app/cubits/CubitState.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/model/ActivitiesModel.dart';
import 'package:life_app/model/NoteModel.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/resources/AppFonts.dart';
import 'package:life_app/ui/pages/AddActivitiesPage.dart';
import 'package:life_app/ui/pages/DetailsPage.dart';
import 'package:life_app/utils/Utils.dart';

class ActivitiesListItem extends StatelessWidget {
  ActivitiesModel listActivity;
  BuildContext scaffoldContext;

  CubitActivities cubitActivities;
  CubitNote noteCubit = CubitNote();
  List<NoteModel> notelist;

  DatabaseHelper databaseHelper;

  ActivitiesListItem(
      this.listActivity, this.scaffoldContext, this.cubitActivities,
      {Key key})
      : super(key: key);
  static const verticalGap = SizedBox(
    height: 5,
  );
  var nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailsPage(this.listActivity),
                ));
          },
          child: Stack(
            children: [
              Container(
                color: AppColors.white,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Icon(
                          Icons.account_circle,
                          size: 60,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      listActivity.activity_name,
                                      style: TextStyle(
                                          fontSize: AppFonts.LARGE_XL,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    listActivity.created_date,
                                    style: TextStyle(
                                        color: AppColors.createdDateColor),
                                  ),
                                ],
                              ),
                              verticalGap,
                              Text(
                                listActivity.description.toString(),
                                style: TextStyle(
                                    fontSize: AppFonts.MEDIUM,
                                    color: AppColors.darkGrey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              verticalGap,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.hourglass_bottom_outlined,
                                    size: 14,
                                  ),
                                  Text(
                                    ": ${listActivity.due_date}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.timeLeftColor,
                                        fontSize: AppFonts.MEDIUM),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        print("InkWell");
                                        _showPopupMenu(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Icon(Icons.more_vert),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocConsumer<CubitActivities, CubitState>(
          cubit: cubitActivities,
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container();
            }
          },
          listener: (context, state) {
            if (state is FailedState) {
              Utils().showToast(state.message);
            } else if (state is SuccessState) {
              Utils().showToast(state.message);
              cubitActivities.fetchActivities();
            }
          },
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) async {
    String selected = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100, 100, 100, 100),
      items: [
        PopupMenuItem<String>(
          child: const Text('Rename'),
          value: "1",
        ),
        PopupMenuItem<String>(child: const Text('Copy Contents'), value: '2'),
        PopupMenuItem<String>(child: const Text('Modify'), value: '3'),
        PopupMenuItem<String>(child: const Text('Clear Content'), value: '4'),
        PopupMenuItem<String>(child: const Text('Delete'), value: '5'),
        PopupMenuItem<String>(
            child: const Text('Download as File'), value: '6'),
      ],
      elevation: 8.0,
    );
    print(selected);
    // ignore: unrelated_type_equality_checks
    switch (selected) {
      case "1":
        _showDialog(context);
        break;

      case "2":
        copyContent();
        break;
      case "3":
        int id = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddActivitiesPage(
                      isUpdate: true,
                      activitiesModel: listActivity,
                    )));
        if (id == null) {
          id = 0;
        }
        if (id > 0) {
          cubitActivities.fetchActivities();
        }
        break;
      case "4":
        clearContent(listActivity.column_id);
        break;
      case "5":
        deleteActivity(listActivity.column_id);
    }
  }

  _showDialog(BuildContext context) async {
    nameController.text = listActivity.activity_name;
    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: new Row(
          children: <Widget>[
            new Expanded(
              child: new TextField(
                controller: nameController,
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: "Activity name", hintText: 'Activity name'),
              ),
            )
          ],
        ),
        actions: <Widget>[
          new FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(scaffoldContext).pop();
              }),
          new FlatButton(
              child: const Text('Submit'),
              onPressed: () async {
                print(nameController.text);
                Map<String, dynamic> maps = {
                  DatabaseHelper.column_name: nameController.text
                };
                int status = await cubitActivities.renameActivities(
                    maps, listActivity.column_id.toString());
                if (status > 0) {
                  Navigator.of(scaffoldContext).pop();
                }
              })
        ],
      ),
    );
  }

  void copyContent() async {
    List<NoteModel> list = await noteCubit.fetchNote(listActivity.column_id);
    String note = "";
    for (int i = 0; i < list.length; i++) {
      note = note + "${list[i].note_name} \n";
    }
    print(note);
    Clipboard.setData(ClipboardData(text: note));
    Utils().showToast("Text Copied");
  }

  void clearContent(int activityId) async {
    databaseHelper = DatabaseHelper.instance;
    int id = await databaseHelper.clearNote(activityId.toString());
    if (id > 0) {
      Utils().showToast("Content Cleared");
    } else {
      Utils().showToast("Failed to clear Content");
    }
  }

  void deleteActivity(int column_id) async {
    databaseHelper = DatabaseHelper.instance;
    List<NoteModel> list = await databaseHelper.fetchNote(column_id);
    if (list.isEmpty) {
      int deleteStatus =
          await databaseHelper.deleteActivity(column_id.toString());
      if (deleteStatus > 0) {
        Utils().showToast("Activity Deleted");
        cubitActivities.fetchActivities();
      } else {
        Utils().showToast("Failed to delete activity");
      }
    } else {
      Utils().showToast("You need to clear content");
    }
  }
}
