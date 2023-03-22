import 'package:flutter/material.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: context.loc.password_reset,
      content: context.loc.password_reset_dialog_prompt,
      optionsBuilder: () => {
            context.loc.ok: null,
          });
}
