import 'package:flutter/material.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog<void>(
      context: context,
      title: 'Password Reset',
      content:
          'We have now sent you a password reset link. Please check your email for more information.',
      optionsBuilder: () => {
            'Ok': null,
          });
}
