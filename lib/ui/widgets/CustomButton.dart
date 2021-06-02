import 'package:flutter/material.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/resources/AppDimens.dart';
import 'package:life_app/resources/AppFonts.dart';

class CustomButton extends StatelessWidget {
  String text;
  VoidCallback pressedCallBack;

  CustomButton(this.text, {this.pressedCallBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        child: Text(text.toUpperCase(),
            style: TextStyle(fontSize: AppFonts.MEDIUM)),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.themeColor),
            padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                vertical: AppDimes.VERTICAL_PADDING_BUTTON)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimes.ROUNDED_RADIUS),
                    side: BorderSide(color: AppColors.themeColor)))),
        onPressed: () {
          pressedCallBack.call();
        },
      ),
    );
  }
}
