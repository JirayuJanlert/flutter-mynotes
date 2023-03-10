import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/Utilities.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/constant/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
    super.initState();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      await showAlertDialogOk(e.toString(), 'Error', context);
    }
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
                          MaterialStateProperty.all(Size.fromHeight(30)),
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
                    await FirebaseAuth.instance.signOut().then((value) {
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
                    await FirebaseAuth.instance.signOut().then((value) {
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
