import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/enums/menu_action.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/cloud/cloud_note.dart';
import 'package:flutter_course/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_course/utilities/dialog/logout_dialog.dart';
import 'package:flutter_course/views/notes/notes_list_view.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  MenuAction? selectedAction;
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorage _notesService;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: StreamBuilder(
                stream: _notesService.allNotes(ownerUserId: userId).getLength,
                builder: (context, AsyncSnapshot<int> snapshot) {
                  if (snapshot.hasData) {
                    final noteCount = snapshot.data ?? 0;
                    return Text(context.loc.notes_title(noteCount));
                  } else {
                    return const Text('');
                  }
                }),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      createOrUpdateNoteRoute,
                    );
                  },
                  icon: const Icon(Icons.add)),
              PopupMenuButton<MenuAction>(
                initialValue: selectedAction,
                onSelected: (value) async {
                  setState(() {
                    selectedAction = value;
                  });
                  switch (value) {
                    case MenuAction.logout:
                      final shouldLogout = await showLogOutDialog(context);
                      if (shouldLogout) {
                        // ignore: use_build_context_synchronously
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      }
                      break;
                    default:
                  }
                },
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: MenuAction.logout,
                      child: ListTile(
                          leading: const Icon(Icons.exit_to_app),
                          title: Text(context.loc.logout_button)),
                    )
                  ];
                },
              ),
            ],
          ),
          body: StreamBuilder<Iterable<CloudNote>>(
              stream: _notesService.allNotes(ownerUserId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final notes = snapshot.data as Iterable<CloudNote>;
                      return NoteListView(
                        notes: notes,
                        onDeleteNote: (note) async {
                          await _notesService.deleteNote(
                              documentId: note.documentId);
                        },
                        onTap: (note) {
                          Navigator.pushNamed(context, createOrUpdateNoteRoute,
                              arguments: note);
                        },
                      );
                    } else {
                      return Text(context.loc.note_view_no_notes);
                    }
                  default:
                    return customLoadingIndicator();
                }
              })),
    );
  }
}
