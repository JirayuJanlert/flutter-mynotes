import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/firebase_auth_provider.dart';
import 'package:flutter_course/views/home_page.dart';
import 'package:flutter_course/views/notes/create_update_note_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      appBarTheme: const AppBarTheme(
        backgroundColor: CustomColor.kSecondaryColor,
        shadowColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
          headlineLarge: TextStyle(
        color: Color(0xFF6078ea),
      )),
      fontFamily: "Poppins-Medium",
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
      ).copyWith(
        secondary: const Color(0xFF5d74e3),
      ),
    ),
    home: BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(FirebaseAuthProvider()),
      child: const HomePage(),
    ),
    routes: {
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}
