import 'package:flutter/material.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/crud/notes_service.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthService.firebase().currentUser!;
      final email = currentUser.email!;
      final owner = await _notesService.getUser(email: email);
      return await _notesService.createNote(owner: owner);
    }
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(noteId: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  void _textcontrollerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextcontroller() {
    _textController.removeListener(_textcontrollerListener);
    _textController.addListener(_textcontrollerListener);
  }

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    _setupTextcontroller();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Note'),
          actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.save))],
        ),
        body: FutureBuilder(
            future: createNewNote(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  _note = snapshot.data as DatabaseNote;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Start Typing your note...',
                      ),
                      style: const TextStyle(
                        fontSize: 19,
                        height: 1.5,
                      ),
                    ),
                  );
                default:
                  return customLoadingIndicator();
              }
            }));
  }
}
