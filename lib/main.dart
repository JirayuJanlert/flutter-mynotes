import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/views/home_page.dart';
import 'package:flutter_course/views/notes_view.dart';
import 'package:flutter_course/views/register_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/views/login_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final firebase =
      Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      textTheme:
          const TextTheme(headlineLarge: TextStyle(color: Color(0xFF6078ea))),
      accentColor: Color(0xFF5d74e3),
      fontFamily: "Poppins-Medium",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: HomePage(
      firebase: firebase,
    ),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
      '/emailverify': (context) => const VerifyEmailView(),
      '/main': (context) => const NotesView()
    },
  ));
}
