import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:life_app/cubits/CubitNote.dart';
import 'package:life_app/cubits/CubitState.dart';
import 'package:life_app/database/DatabaseHelper.dart';
import 'package:life_app/model/ActivitiesModel.dart';
import 'package:life_app/model/NoteModel.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/ui/widgets/AddNoteWidget.dart';
import 'package:life_app/ui/widgets/NoteListItem.dart';
import 'package:life_app/utils/DateHelper.dart';
import 'package:life_app/utils/ShareService.dart';

class DetailsPage extends StatefulWidget {
  ActivitiesModel listActivity;

  DetailsPage(this.listActivity, {Key key}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState(listActivity);
}

class _DetailsPageState extends State<DetailsPage> {
  AppBar appBar;
  ActivitiesModel listActivity;

  Widget appBarTitle;

  _DetailsPageState(this.listActivity);

  ScrollController controller = new ScrollController();

  CubitNote _cubitNote = CubitNote();
  List<NoteModel> noteList;
  final TextEditingController _controllerSearch = new TextEditingController();
  bool _isSearching = false;
  String _searchText = "";
  List<NoteModel> searchResult = List();

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );

  @override
  void initState() {
    _cubitNote.fetchNote(listActivity.column_id);
    appBarTitle = new Text(
      listActivity.activity_name,
      style: new TextStyle(color: Colors.white),
    );

    _controllerSearch.addListener(() {
      if (_controllerSearch.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = _controllerSearch.text;
        });
      }
    });
    ShareService()
    // Register a callback so that we handle shared data if it arrives while the
    // app is running
      ..onDataReceived = _handleSharedData

    // Check to see if there is any shared data already, meaning that the app
    // was launched via sharing.
      ..getSharedData().then(_handleSharedData);
  }

  Widget appBarWidget() {
    return appBar = AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: appBarTitle,
      actions: [
        IconButton(
          icon: icon,
          onPressed: () {
            setState(() {
              if (this.icon.icon == Icons.search) {
                this.icon = new Icon(
                  Icons.close,
                  color: Colors.white,
                );
                this.appBarTitle = new TextField(
                  controller: _controllerSearch,
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  decoration: new InputDecoration(
                      prefixIcon: new Icon(Icons.search, color: Colors.white),
                      hintText: "Search...",
                      hintStyle: new TextStyle(color: Colors.white)),
                  onChanged: searchOperation,
                );
                _handleSearchStart();
              } else {
                _handleSearchEnd();
              }
            });
          },
        ),
        PopupMenuButton(
          onSelected: handleClick,
          itemBuilder: (context) {
            return {'Download Content'}.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.themeColor,
        accentColor: Colors.cyan[600],
      ),
      home: Scaffold(
        appBar: appBarWidget(),
        body: Container(
          color: AppColors.noteBackgroundColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 70),
                child: Container(
                    height: double.maxFinite,
                    child: searchResult.length != 0 || _controllerSearch.text.isNotEmpty
                        ? successWidget(searchResult):BlocConsumer<CubitNote, CubitState>(
                      cubit: _cubitNote,
                      listener: (context, state) {},
                      builder: (context, state) {
                        return handleState(context, state);
                      },
                    )),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                    color: AppColors.noteBackgroundColor,
                    child: AddNoteWidget(
                        listActivity.column_id, _cubitNote, controller)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget handleState(BuildContext context, CubitState state) {
    if (state is FailedState) {
      return Center(
        child: Text("No Note Found, add One"),
      );
    } else if (state is SuccessState) {
      noteList = _cubitNote.noteList;
      return successWidget(noteList);
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Download Content':
        break;
    }
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    print("Search $searchText");
    if (_isSearching != null) {
      for (int i = 0; i < noteList.length; i++) {
        String data = noteList[i].note_name;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(noteList[i]);
        }
      }
    }
  }

  void _handleSearchStart() {
    setState(() {
      _isSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.icon = new Icon(
        Icons.search,
        color: Colors.white,
      );
      this.appBarTitle = new Text(
        listActivity.activity_name,
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controllerSearch.clear();
      searchResult.clear();
    });
  }

  Widget successWidget(List<NoteModel> list) {
    return ListView.builder(
      itemCount: list.length,
      controller: controller,
      itemBuilder: (context, index) {
        return NoteListItem(list[index]);
      },
    );
  }

  void _handleSharedData(String sharedData) {
    print("Shared data $sharedData");
    if(sharedData.isNotEmpty)
      {
        addNote(sharedData, listActivity.column_id);
      }
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
    var id = await _cubitNote.addNote(maps);
    if (id > 0) {
      _cubitNote.fetchNote(IdActvity);
    }
  }

}
