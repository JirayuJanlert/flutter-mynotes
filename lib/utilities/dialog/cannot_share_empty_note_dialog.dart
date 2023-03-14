import 'package:flutter/widgets.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'You cannot share an empy note!',
    optionsBuilder: () => {'OK': null},
  );
}
