
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/custom_icon.dart';
import 'dart:developer' as devtools show log;

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  MenuAction? selectedAction;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomColor.kSecondaryColor,
        shadowColor: Colors.transparent,
        title: const Text('MyNote'),
        actions: [
          PopupMenuButton<MenuAction>(
            initialValue: selectedAction,
            onSelected: (value) async {
              setState(() {
                selectedAction = value;
              });
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
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
      body: Center(
          child: Text(
        'Main UI',
        style: Theme.of(context).textTheme.displayMedium,
      )),
    );
  }
}

enum MenuAction { logout }

Future<bool> showLogOutDialog(BuildContext context) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Logout')),
        ],
      );
    },
  ).then((value) => value ?? false);
}
