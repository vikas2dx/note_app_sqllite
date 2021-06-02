import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:life_app/cubits/CubitActivities.dart';
import 'package:life_app/cubits/CubitState.dart';
import 'package:life_app/model/ActivitiesModel.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/resources/AppStrings.dart';
import 'package:life_app/ui/pages/AddActivitiesPage.dart';
import 'package:life_app/ui/widgets/ActivitiesListItemWidget.dart';
import 'package:life_app/utils/ShareService.dart';

class ActivitiesPage extends StatefulWidget {
  const ActivitiesPage({Key key}) : super(key: key);

  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  CubitActivities cubitActivities;
  List<ActivitiesModel> listActivity;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _controllerSearch = new TextEditingController();
  bool _isSearching = false;
  String _searchText = "";
  List<ActivitiesModel> searchResult = List();

  Icon icon = new Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget appBarTitle = new Text(
    AppStrings.ACTIVITIES,
    style: new TextStyle(color: Colors.white),
  );

  void handleClick(String value) {
    switch (value) {
      case 'Download Content':
        break;
    }
  }

  @override
  void initState() {
    cubitActivities = CubitActivities();
    cubitActivities.fetchActivities();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: searchResult.length != 0 || _controllerSearch.text.isNotEmpty
            ? successWidget(searchResult)
            : BlocConsumer<CubitActivities, CubitState>(
                cubit: cubitActivities,
                listener: (context, state) {},
                builder: (context, state) {
                  return handleState(context, state);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColors.themeColor,
        onPressed: () async {
          int id = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddActivitiesPage(),
              ));
          if (id > 0) {
            cubitActivities.fetchActivities();
          }
        },
      ),
    );
  }

  Widget handleState(BuildContext context, CubitState state) {
    if (state is FailedState) {
      return Center(
        child: Text("No Activity Found, add One"),
      );
    } else if (state is SuccessState) {
      listActivity = cubitActivities.activitiesList;
      return successWidget(listActivity);
    } else if (state is LoadingState) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void searchOperation(String searchText) {
    searchResult.clear();
    print("Search $searchText");
    if (_isSearching != null) {
      for (int i = 0; i < listActivity.length; i++) {
        String data = listActivity[i].activity_name;
        if (data.toLowerCase().contains(searchText.toLowerCase())) {
          searchResult.add(listActivity[i]);
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
        AppStrings.ACTIVITIES,
        style: new TextStyle(color: Colors.white),
      );
      _isSearching = false;
      _controllerSearch.clear();
       searchResult.clear();
    });
  }

  Widget successWidget(List<ActivitiesModel> list) {
    return ListView.separated(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return ActivitiesListItem(
            list[index], _scaffoldKey.currentContext, cubitActivities);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        height: 1,
      ),
    );
  }

  void _handleSharedData(String sharedData) {
    print("Shared data $sharedData");
  }
}
