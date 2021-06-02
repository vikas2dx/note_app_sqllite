import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  static Color themeColor = HexColor("075E54");
  static Color createdDateColor = HexColor("686868");
  static Color timeLeftColor = HexColor("FF0000");
  static Color darkGrey = HexColor("686868");
  static const grey=Colors.grey;
  static Color noteCardColor=HexColor("daf7c1");
  static Color noteBackgroundColor=HexColor("ece3da");
  static Color white=HexColor("ffffff");

}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
