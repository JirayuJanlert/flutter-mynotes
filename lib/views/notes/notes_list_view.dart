import 'package:flutter/material.dart';
import 'package:flutter_course/services/crud/notes_service.dart';
import 'package:flutter_course/utilities/dialog/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NoteListView(
      {super.key, required this.notes, required this.onDeleteNote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, i) {
          final note = notes[i];
          return ListTile(
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () async {
                  final shouldDelete = await showDeleteDialog(context);
                  if (shouldDelete) {
                    onDeleteNote(note);
                  }
                },
                icon: const Icon(Icons.delete)),
          );
        });
  }
}
