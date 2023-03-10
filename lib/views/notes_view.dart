import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/Utilities.dart';
import 'package:flutter_course/constant/custom.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_course/constant/routes.dart';

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
                  final shouldLogout = await showDialogActions(
                      context,
                      'Are you sure you want to sign out?',
                      'Sign Out',
                      'Cancel',
                      'Confirm');
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
