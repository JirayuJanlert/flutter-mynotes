import 'package:flutter/material.dart';

Future<void> showAlertDialog(
    String message, String title, BuildContext context, VoidCallback function) {
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: function,
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
