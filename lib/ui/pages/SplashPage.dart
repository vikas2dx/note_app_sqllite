import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:life_app/ui/pages/ActivitiesPage.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/resources/AppDimens.dart';
import 'package:life_app/resources/AppFonts.dart';
import 'package:life_app/resources/AppImages.dart';
import 'package:life_app/resources/AppStrings.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.themeColor
    ));
    return  Scaffold(
        body: Container(
            width: double.infinity,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.LOGO,
                  height: AppDimes.LOGO_SIZE,
                  width: AppDimes.LOGO_SIZE,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  AppStrings.APP_NAME,
                  style: TextStyle(
                      color: Colors.black, fontSize: AppFonts.LARGE_XL),
                ),
              ],
            )),
      );
  }

  @override
  void initState() {
    Timer(Duration(seconds: 2), () async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ActivitiesPage(),
          ));
    });
  }
}
