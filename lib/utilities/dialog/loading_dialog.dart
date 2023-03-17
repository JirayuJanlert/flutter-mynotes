import 'package:flutter/material.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';

typedef CloseDialog = void Function();

CloseDialog showLoadingDialog({
  required BuildContext context,
  required String text,
}) {
  final dialog = AlertDialog(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        customLoadingIndicator(),
        const SizedBox(
          height: 10.0,
        ),
        Text(text),
      ],
    ),
  );

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => dialog,
  );

  return () => Navigator.of(context).pop();
}
