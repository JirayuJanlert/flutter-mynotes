import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/helpers/loading/loading_screen.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';
import 'package:flutter_course/views/forgot_password_view.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_course/views/notes/notes_view.dart';
import 'package:flutter_course/views/register_view.dart';
import 'package:flutter_course/views/veiry_email_view.dart';
import 'package:flutter_course/widgets/loading_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    ScreenUtil.init(
      context,
      designSize: screenSize,
      scaleByHeight: true,
      minTextAdapt: true,
      splitScreenMode: true,
    );
    context.read<AuthBloc>().add(const AuthEventInitialize());

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please ait a moment');
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return Scaffold(body: customLoadingIndicator());
        }
      },
    );
  }
}
