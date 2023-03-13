import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_course/services/auth/auth_service.dart';
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
              size: 250.sp,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            const Text(
              'A verification email has been sent to your email',
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextButton.icon(
                  style: ButtonStyle(
                      minimumSize:
                          MaterialStateProperty.all(const Size.fromHeight(30)),
                      backgroundColor:
                          MaterialStateProperty.all(CustomColor.kPrimaryColor)),
                  onPressed: canResendEmail
                      ? () async => await sendVerificationEmail()
                      : null,
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Resend email verification',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(20),
            ),
            TextButton(
                onPressed: () async {
                  if (mounted) {
                    await authService.logOut().then((value) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginRoute, (route) => false);
                    });
                  }
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
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
              size: 250.sp,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            const Text(
              "Email is verified",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ScreenUtil().setHeight(200),
            ),
            TextButton(
                onPressed: () async {
                  if (mounted) {
                    await authService.logOut().then((_) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, loginRoute, (route) => false);
                    });
                  }
                },
                child: const Text('Go to Login')),
          ]),
        ),
      );
    }
  }
}
