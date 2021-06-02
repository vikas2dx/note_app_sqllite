import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:life_app/cubits/CubitActivities.dart';
import 'package:life_app/cubits/UiCubit.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/model/ActivitiesModel.dart';
import 'package:life_app/resources/AppDimens.dart';
import 'package:life_app/resources/AppStrings.dart';
import 'package:life_app/ui/widgets/CustomButton.dart';
import 'package:life_app/ui/widgets/CustomTextFormField.dart';
import 'package:life_app/utils/DateHelper.dart';

class AddActivitiesPage extends StatefulWidget {
  bool isUpdate;
  ActivitiesModel activitiesModel;

  AddActivitiesPage({this.isUpdate = false, this.activitiesModel}) : super();

  @override
  _AddActivitiesPageState createState() =>
      _AddActivitiesPageState(isUpdate, activitiesModel);
}

class _AddActivitiesPageState extends State<AddActivitiesPage> {
  var verticalGap = SizedBox(
    height: 10,
  );
  bool isUpdate = false;
  ActivitiesModel activitiesModel;
  CubitActivities cubitActivities = CubitActivities();
  var nameController = TextEditingController();
  var createdDateController = TextEditingController();
  var dueDateController = TextEditingController();

  _AddActivitiesPageState(this.isUpdate, this.activitiesModel);

  @override
  void initState() {
    if (isUpdate) {
      nameController.text = activitiesModel.activity_name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? AppStrings.UPDATE_PAGE : AppStrings.ADD_PAGE),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.all(AppDimes.LAYOUT_MARGIN),
            child: Column(
              children: [
                CustomTextFormField(
                  AppStrings.ACTIVITIES_NAME,
                  controller: nameController,
                ),
                verticalGap,
                InkWell(
                  onTap: () {
                    _selectDueDate();
                  },
                  child: IgnorePointer(
                    child: CustomTextFormField(
                      AppStrings.REMINDER_DATE,
                      controller: dueDateController,
                    ),
                  ),
                ),
                verticalGap,
                CustomButton(
                  isUpdate ? AppStrings.UPDATE : AppStrings.ADD,
                  pressedCallBack: () async {
                    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                    String createdDate = await DateHelper().getFormatedDateTime(
                        dateFormat.parse(dateFormat.format(DateTime.now())));
                    if (isUpdate) {
                      updateActivities(
                          nameController.text,
                          createdDate,
                          dueDateController.text,
                          context,
                          activitiesModel.column_id.toString());
                    } else {
                      addNewActivities(nameController.text, createdDate,
                          dueDateController.text, context);
                    }
                  },
                ),
              ],
            ),
          ),
          BlocBuilder<UICubit<bool>, bool>(
            cubit: cubitActivities.loaderCubit,
            builder: (context, loading) {
              return loading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container();
            },
          )
        ],
      ),
    );
  }

  void addNewActivities(
      String name, String createDate, String dueDate, BuildContext context) {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> map = {
      DatabaseHelper.column_name: name,
      DatabaseHelper.column_created_date: createDate,
      DatabaseHelper.column_due_date: dueDate,
      DatabaseHelper.timeStamp: timeStamp
    };
    cubitActivities.addActivities(map, context);
  }

  void updateActivities(String name, String createDate, String dueDate,
      BuildContext context, String activityId) {
    int timeStamp = DateTime.now().millisecondsSinceEpoch;
    Map<String, dynamic> map = {
      DatabaseHelper.column_name: name,
      DatabaseHelper.column_created_date: createDate,
      DatabaseHelper.column_due_date: dueDate,
      DatabaseHelper.timeStamp: timeStamp
    };
    cubitActivities.updateActivities(map, context, activityId);
  }

  void _selectDueDate() async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    var formatedDate = await DateHelper().getFormatedDateTime(date);
    dueDateController.text = formatedDate;
  }
}
