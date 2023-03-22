import 'package:flutter/widgets.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/utilities/dialog/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: context.loc.sharing,
    content: context.loc.cannot_share_empty_note_prompt,
    optionsBuilder: () => {context.loc.ok: null},
  );
}
