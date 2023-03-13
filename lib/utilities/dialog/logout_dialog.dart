import 'package:flutter/material.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
          context: context,
          title: 'Log out',
          content: 'Are you sure you want to log out?',
          optionsBuilder: () => {'Cancel': false, 'Log Out': true})
      .then((value) => value ?? false);
}
