import 'package:flutter/material.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/views/notes/notes_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/views/welcome_view.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              return customLoadingIndicator();
          }
        });
  }
}
