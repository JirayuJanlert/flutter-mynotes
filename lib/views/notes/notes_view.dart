import 'package:flutter/material.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/enums/menu_action.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/crud/notes_service.dart';
import 'package:flutter_course/utilities/dialog/logout_dialog.dart';
import 'package:flutter_course/views/notes/notes_list_view.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  MenuAction? selectedAction;
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesService _notesService;

  @override
  void initState() {
    _notesService = NotesService();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
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
                    await AuthService.firebase().logOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                  }
                  break;
                default:
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                    value: MenuAction.logout,
                    child: ListTile(
                      leading: Icon(Icons.exit_to_app),
                      title: Text('Signout'),
                    ))
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder<List<DatabaseNote>>(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final notes = snapshot.data as List<DatabaseNote>;
                          return NoteListView(
                            notes: notes,
                            onDeleteNote: (note) async {
                              await _notesService.deleteNote(noteId: note.id);
                            },
                            onTap: (note) {
                              Navigator.pushNamed(
                                  context, createOrUpdateNoteRoute,
                                  arguments: note);
                            },
                          );
                        } else {
                          return const Text('No notes');
                        }
                      default:
                        return customLoadingIndicator();
                    }
                  });
            default:
              return customLoadingIndicator();
          }
        },
      ),
    );
  }
}
