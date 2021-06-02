import 'package:flutter/material.dart';
import 'package:life_app/resources/AppColors.dart';
import 'package:life_app/resources/AppDimens.dart';
import 'package:life_app/resources/AppFonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  CustomTextFormField(this.hintText,{this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        contentPadding:
        EdgeInsets.symmetric(horizontal: AppDimes.HORIZONTAL_PADDING_TEXTFIELD,
            vertical: AppDimes.VERTICAL_PADDING_TEXTFIELD),
        hintText: hintText,
        labelText: hintText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimes.ROUNDED_RADIUS),
            borderSide: BorderSide(
                color: AppColors.grey, width: 1)),
      ),
      style: TextStyle(fontSize: AppFonts.MEDIUM),
    );
  }
}
