import 'package:flutter/material.dart';

Future<void> showAlertDialogOk(
    String message, String title, BuildContext context) {
  Widget okButton = TextButton(
    onPressed: () => Navigator.pop(context),
    child: const Text("OK"),
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message),
    actions: [
      okButton,
    ],
  );

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Future<bool> showDialogActions(BuildContext context, String message,
    String title, String firstButtonText, String secondButtonText) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(firstButtonText)),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(secondButtonText)),
        ],
      );
    },
  ).then((value) => value ?? false);
}
