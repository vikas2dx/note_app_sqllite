import 'package:flutter/material.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/ui/pages/SplashPage.dart';

void main() {
  runApp(MaterialApp(
    title: 'Life app',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: AppColors.themeColor,
      buttonColor: AppColors.themeColor,
      brightness: Brightness.light,
      accentColor: Colors.cyan[600],
      fontFamily: 'Roboto',
      primarySwatch: Colors.blue,
    ),
    home: SplashPage(),
  ));
}
