import 'dart:async';

import 'package:life_app/model/ActivitiesModel.dart';
import 'package:life_app/model/NoteModel.dart';
import 'package:life_app/utils/DateHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  String descriptions = "No Entries";

  DatabaseHelper._privateConstructor();

  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 2;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;
  static final _tableNameActivity = 'activities';
  static final column_id = 'column_id';
  static final column_name = 'activity_name';
  static final column_created_date = 'created_date';
  static final column_due_date = 'due_date';
  static final timeStamp = 'timeStamp';

  static final _tableNote = 'note';
  static final activity_id = 'activity_id';
  static final note_id = 'note_id';
  static final note_name = 'note_name';
  static final note_created_date = 'note_created_date';
  static final note_due_date = 'note_due_date';
  static final note_timeStamp = 'note_timeStamp';

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $_tableNameActivity (
    $column_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $column_name TEXT NOT NULL,
    $column_created_date TEXT,
    $column_due_date TEXT,
    $timeStamp INTEGER
    )
    ''');
    await db.execute('''CREATE TABLE $_tableNote (
    $note_id INTEGER PRIMARY KEY AUTOINCREMENT,
    $activity_id INTEGER,
    $note_name TEXT NOT NULL,
    $note_created_date TEXT,
    $note_due_date TEXT,
    $note_timeStamp INTEGER
    )
    ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableNameActivity, row);
  }

  Future<int> updateActivities(Map<String, dynamic> row, String id) async {
    Database db = await instance.database;
    return await db.update(_tableNameActivity, row, where: column_id + "= $id");
  }

  Future<List<ActivitiesModel>> fetchActivities() async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      _tableNameActivity,
      orderBy: timeStamp + " DESC",
    );
    List<ActivitiesModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      String createdTime =
          await DateHelper().getCreatedTime(maps[i][column_created_date]);
      String dueTime = await DateHelper().getDueTime(maps[i][column_due_date]);
      List<NoteModel> notemodel =
          await fetchNoteByID(maps[i][column_id].toString());
      if (notemodel.length > 0) {
        descriptions = notemodel[0].note_name;
      }

      list.add(ActivitiesModel(
          column_id: maps[i][column_id],
          timeStamp: maps[i][timeStamp],
          activity_name: maps[i][column_name],
          created_date: createdTime,
          due_date: dueTime,
          description: descriptions));
    }
    return list;
  }

  Future<int> renameActivity(
      Map<String, dynamic> maps, String activityId) async {
    final Database db = await instance.database;
    int updateStatus = await db.update(_tableNameActivity, maps,
        where: column_id + "=$activityId");
    return updateStatus;
  }


  Future<List<NoteModel>> fetchNote(int activityId) async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps =
        await db.query(_tableNote, where: activity_id + " =$activityId");
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      String createdTime =
          await DateHelper().getCreatedTime(maps[i][note_created_date]);
      String dueTime = await DateHelper().getDueTime(maps[i][note_due_date]);
      list.add(NoteModel(
          note_id: maps[i][note_id],
          activity_id: maps[i][activity_id],
          note_timeStamp: maps[i][note_timeStamp],
          note_name: maps[i][note_name],
          note_created_date: createdTime,
          note_due_date: dueTime));
    }
    return list;
  }

  Future<int> addNote(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(_tableNote, row);
  }

  Future<List<NoteModel>> fetchNoteByID(String id) async {
    final Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(_tableNote,
        where: activity_id + "= $id", orderBy: note_id + " DESC LIMIT 1");
    List<NoteModel> list = List();
    for (int i = 0; i < maps.length; i++) {
      String createdTime =
          await DateHelper().getCreatedTime(maps[i][note_created_date]);
      String dueTime = await DateHelper().getDueTime(maps[i][note_due_date]);
      list.add(NoteModel(
          note_id: maps[i][note_id],
          activity_id: maps[i][activity_id],
          note_timeStamp: maps[i][note_timeStamp],
          note_name: maps[i][note_name],
          note_created_date: createdTime,
          note_due_date: dueTime));
    }
    return list;
  }

  Future<int> clearNote(String activityId) async {
    Database db = await instance.database;
    return await db.delete(_tableNote, where: activity_id + "= $activityId");
  }
  Future<int> deleteActivity(String activityId)async
  {
    Database db = await instance.database;
    return await db.delete(_tableNameActivity, where: column_id + "= $activityId");
  }
}
