import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/utilities/dialog/error_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  final AuthService authService = AuthService.firebase();
  Timer? timer;

  @override
  void initState() {
    isEmailVerified = authService.currentUser!.isEmailVerified;

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
    super.initState();
  }

  Future sendVerificationEmail() async {
    try {
      await authService.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      showErrorDialog(context, e.toString());
    }
  }

  Future checkEmailVerified() async {
    await authService.reload();
    setState(() {
      isEmailVerified = authService.currentUser!.isEmailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!isEmailVerified) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.verified,
              color: Colors.black38,
              size: 120.sp,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Text(
              context.loc.verify_email_view_prompt,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton.icon(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(30)),
                      backgroundColor: canResendEmail
                          ? MaterialStateProperty.all(
                              CustomColor.kSecondaryColor)
                          : MaterialStateProperty.all(Colors.grey)),
                  onPressed: canResendEmail
                      ? () => context
                          .read<AuthBloc>()
                          .add(const AuthEventSendEmailVerification())
                      : null,
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: Text(
                    context.loc.verify_email_resend_email_verification,
                    style: const TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(10),
            ),
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(
                  context.loc.cancel,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                )),
          ]),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              Icons.verified,
              color: Colors.blue,
              size: 120.sp,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Text(
              context.loc.verify_email_verification_success,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
                child: Text(context.loc.back_to_login)),
          ]),
        ),
      );
    }
  }
}
