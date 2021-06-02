import 'package:intl/intl.dart';

class DateHelper {
  Future<String> getFormatedDate(DateTime dateTime) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  Future<String> getFormatedDateTime(DateTime dateTime) async {
    String dateFormated =
        DateFormat('yyyy-MM-dd').format(dateTime); //date format

    String timeFormat =
        DateFormat("HH:mm:ss").format(DateTime.now()); //time format
    String createdDate = "$dateFormated $timeFormat";

    return createdDate;
  }

  Future<String> getTimeCreatedDateFormat(String dateTime) async {
    DateTime dateTimeFormat =
        new DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    String timeFormat =
        DateFormat("HH:mm").format(dateTimeFormat); //time format
    return timeFormat;
  }

  Future<String> getTimeDueDateFormat(String dateTime) async {
    String dueTime = "00:00";
    print(dateTime);
    DateTime dueDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateTime);
    DateTime dateTimeNow = DateTime.now();
    int dayDifference = dueDate.difference(dateTimeNow).inDays;
    int minutesDifference = dueDate.difference(dateTimeNow).inMinutes;
    if (dayDifference < 0) {
      return dueTime;
    } else if (dayDifference == 0) {
      if (minutesDifference > 0) {
        return durationToString(minutesDifference);
      } else {
        return dueTime;
      }
    } else {
      dueTime = "$dayDifference day";
      return dueTime;
    }
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  Future<String> getCreatedTime(column_created_date) async {
    String time =
    await DateHelper().getTimeCreatedDateFormat(column_created_date);
    return time;
  }

  Future<String> getDueTime(colume_due_date) async {
    String time = await DateHelper().getTimeDueDateFormat(colume_due_date);
    return time;
  }
}
