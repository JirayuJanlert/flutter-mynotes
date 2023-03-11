import 'package:flutter/material.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/views/notes_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/views/welcome_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService.firebase();
    ScreenUtil.init(context, designSize: const Size(1080, 2340));

    return FutureBuilder(
        future: authService.initialiize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = authService.currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const SafeArea(child: NotesView());
                } else {
                  return const VerifyEmailView();
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
