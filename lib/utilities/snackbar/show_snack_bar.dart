import 'package:flutter/material.dart';
import 'package:flutter_course/constant/custom.dart';

void showSnackBar(BuildContext context, String message) {
  final SnackBar snackBar = SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontFamily: CustomTextStyle.kDefaultMediumFont,
      ),
    ),
    backgroundColor: CustomColor.kSecondaryColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
