import 'package:flutter/material.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/cloud/cloud_note.dart';
import 'package:flutter_course/utilities/dialog/cannot_share_empty_note_dialog.dart';
import 'package:flutter_course/utilities/generics/get_arguments.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';
import 'package:flutter_course/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  String appBarTitle = 'New Note';

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      final currentUser = AuthService.firebase().currentUser!;
      // final owner = await _notesService.getNotes(email: email);
      final newNote =
          await _notesService.createNewNote(ownerUserId: currentUser.id);
      _note = newNote;
      return newNote;
    }
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      await _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (_textController.text.isNotEmpty && note != null) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  void _textcontrollerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextcontroller() {
    _textController.removeListener(_textcontrollerListener);
    _textController.addListener(_textcontrollerListener);
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
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
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            actions: [
              IconButton(
                  onPressed: () async {
                    final text = _textController.text;
                    if (_note == null || text.isEmpty) {
                      await showCannotShareEmptyNoteDialog(context);
                    } else {
                      Share.share(text);
                    }
                  },
                  icon: const Icon(Icons.ios_share))
            ],
          ),
          body: FutureBuilder(
              future: createOrGetExistingNote(context),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
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
              })),
    );
  }
}
