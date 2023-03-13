import 'package:flutter/material.dart';
import 'package:flutter_course/Utilities.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/enums/menu_action.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/crud/notes_service.dart';
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
  void dispose() {
    _notesService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, newNoteRoute);
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
                  final shouldLogout = await showDialogActions(
                      context,
                      'Are you sure you want to sign out?',
                      'Sign Out',
                      'Cancel',
                      'Confirm');
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
                        return Center(
                            child: Text(
                          'Waiting for all your notes',
                          style: theme.textTheme.bodyLarge,
                        ));
                      case ConnectionState.done:
                        return Center(
                            child: Text(
                          'Main UI',
                          style: Theme.of(context).textTheme.displayMedium,
                        ));
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
