import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/services/auth/auth_exception.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/services/auth/bloc/auth_event.dart';
import 'package:flutter_course/services/auth/bloc/auth_state.dart';
import 'package:flutter_course/utilities/dialog/error_dialog.dart';
import 'package:flutter_course/widgets/horrizontal_line.dart';
import 'package:flutter_course/widgets/radio_button.dart';
import 'package:flutter_course/widgets/social_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _username;
  late final TextEditingController _password;
  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  void initState() {
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception != null) {
            if (state.exception is UserNotFoundAuthException) {
              await showErrorDialog(
                context,
                context.loc.login_error_cannot_find_user,
              );
            } else if (state.exception is WrongPasswordAuthException) {
              await showErrorDialog(
                context,
                context.loc.login_error_wrong_credentials,
              );
            } else if (state.exception is GenericAuthException) {
              await showErrorDialog(
                context,
                context.loc.login_error_auth_error,
              );
            } else if (state.exception is GoogleSignInAuthException) {
              await showErrorDialog(
                context,
                context.loc.login_error_google_auth_error,
              );
            } else {
              await showErrorDialog(
                context,
                context.loc.login_error_auth_error,
              );
            }
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(fit: StackFit.expand, children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 10),
                    alignment: Alignment.topRight,
                    child: Image.asset(
                      'assets/image_01.png',
                    )),
                Expanded(child: Container()),
                Image.asset('assets/image_02.png')
              ],
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 60.h,
                          width: 40.w,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text('NOTESY',
                            style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                fontSize: 30.sp,
                                color: theme.textTheme.headlineLarge?.color,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w),
                    child: Card(
                      borderOnForeground: true,
                      color: theme.cardColor,
                      shadowColor: theme.shadowColor,
                      elevation: 20,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                          padding: const EdgeInsets.all(20),
                          width: double.infinity,
                          height: ScreenUtil().setHeight(400),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                context.loc.login,
                                style: theme.textTheme.headlineMedium,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                context.loc.email_text_field_label,
                                style: theme.textTheme.labelLarge,
                              ),
                              TextField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    hintText: context
                                        .loc.email_text_field_placeholder,
                                    labelStyle: theme.textTheme.labelLarge,
                                    prefixIcon: const Icon(Icons.people),
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color:
                                            theme.hintColor), //hint text style
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                // context.loc.password_textfield_label,
                                context.loc.password_text_field_label,
                                style: theme.textTheme.labelLarge,
                              ),
                              TextField(
                                  obscureText: true,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    hintText: context
                                        .loc.password_text_field_placeholder,
                                    labelStyle: theme.textTheme.labelLarge,
                                    prefixIcon: const Icon(Icons.password),
                                    hintStyle: TextStyle(
                                        fontSize: 16,
                                        color:
                                            theme.hintColor), //hint text style
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                    onPressed: () => context
                                        .read<AuthBloc>()
                                        .add(const AuthEventForgotPassword()),
                                    child: Text(
                                      context.loc.login_view_forgot_password,
                                      style: TextStyle(
                                          color: theme.colorScheme.secondary,
                                          fontSize: 15),
                                    ),
                                  )
                                ],
                              )
                            ],
                          )),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              onTap: _radio, child: radioButton(_isSelected)),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            context.loc.login_view_remember_me,
                            style: theme.textTheme.bodyLarge,
                          )
                        ],
                      ),
                      Container(
                        width: 150.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              CustomColor.kPrimaryColor,
                              CustomColor.kSecondaryColor
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFF6078ea).withOpacity(.3),
                                  offset: const Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                final email = _username.text;
                                final password = _password.text;
                                context
                                    .read<AuthBloc>()
                                    .add(AuthEventLogIn(email, password));
                              },
                              child: Center(
                                child: Text(context.loc.login,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0,
                                    )),
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      horizontalLine(),
                      Text(
                        context.loc.login_view_social_login,
                        style: theme.textTheme.titleLarge,
                      ),
                      horizontalLine(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SocialIcon(
                        colors: const [
                          Color(0xFF102397),
                          Color(0xFF187adf),
                          Color(0xFF00eaf8),
                        ],
                        iconData: CustomIcons.facebook,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: const [
                          Color(0xFFff4f38),
                          Color(0xFFff355d),
                        ],
                        iconData: CustomIcons.googlePlus,
                        onPressed: () async {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventLogInWithGoogle());
                        },
                      ),
                      SocialIcon(
                        colors: const [
                          CustomColor.kPrimaryColor,
                          Color(0xFF6078ea),
                        ],
                        iconData: CustomIcons.twitter,
                        onPressed: () {},
                      ),
                      SocialIcon(
                        colors: const [
                          Color(0xFF00c6fb),
                          Color(0xFF005bea),
                        ],
                        iconData: CustomIcons.linkedin,
                        onPressed: () {},
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        context.loc.login_view_new_user,
                        style: const TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                        child: Text(context.loc.login_view_sign_up,
                            style: const TextStyle(
                              color: Color(0xFF5d74e3),
                              fontFamily: "Poppins-Bold",
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
