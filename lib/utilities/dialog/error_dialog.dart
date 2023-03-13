import 'package:flutter/material.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
      title: 'An error occured',
      content: text,
      context: context,
      optionsBuilder: () => {
            'Ok': null,
          });
}
