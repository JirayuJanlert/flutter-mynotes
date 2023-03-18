import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';
import 'package:flutter_course/utilities/dialog/error_dialog.dart';
import 'package:flutter_course/utilities/dialog/password_reset.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if (state.exception != null) {
            if (mounted) {
              await showErrorDialog(
                context,
                'We could not process your request. Please make sure that you are a registered user, or if not, please register one.',
              );
            }
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restore,
                      color: Colors.grey,
                      size: 120.sp,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    Text(
                      'Please input an email of account you want to reset the email.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      autofocus: true,
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Please input email address...',
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(30),
                    ),
                    TextButton.icon(
                      icon: const Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final email = _controller.text;
                        context
                            .read<AuthBloc>()
                            .add(AuthEventForgotPassword(email: email));
                      },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(30)),
                          backgroundColor: MaterialStateProperty.all(
                              CustomColor.kSecondaryColor)),
                      label: const Text(
                        'Send email',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventLogOut(),
                            );
                      },
                      child: const Text(
                        'Go back to login',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
