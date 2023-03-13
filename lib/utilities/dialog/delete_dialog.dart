import 'package:flutter/material.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog(
          context: context,
          title: 'Delete',
          content: 'Are you sure you want to delete this note?',
          optionsBuilder: () => {'Cancel': false, 'Confirm': true})
      .then((value) => value ?? false);
}
