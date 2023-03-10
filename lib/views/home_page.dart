import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/views/notes_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_course/views/welcome_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatelessWidget {
  final Future<FirebaseApp> firebase;

  const HomePage({super.key, required this.firebase});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ScreenUtil.init(context, designSize: const Size(1080, 2340));

    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                if (user.emailVerified) {
                  return SafeArea(child: const NotesView());
                } else {
                  return VerifyEmailView();
                }
              } else {
                return const WelcomeScreen();
              }
            default:
              return Center(
                  child: LoadingAnimationWidget.twistingDots(
                leftDotColor: const Color(0xFF1A1A3F),
                rightDotColor: Theme.of(context).colorScheme.secondary,
                size: 200,
              ));
          }
        });
  }
}
