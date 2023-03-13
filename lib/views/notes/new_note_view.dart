import 'package:flutter/material.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Note'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: const TextField(
            controller: null,
            maxLines: null,
            textCapitalization: TextCapitalization.sentences,
            decoration: null,
            style: TextStyle(
              fontSize: 19,
              height: 1.5,
            ),
          ),
        ));
  }
}
