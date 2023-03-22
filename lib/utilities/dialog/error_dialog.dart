import 'package:flutter/material.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
      title: context.loc.generic_error_prompt,
      content: text,
      context: context,
      optionsBuilder: () => {
            context.loc.ok: null,
          });
}
