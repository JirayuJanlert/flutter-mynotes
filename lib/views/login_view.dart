import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              'Cannot find a user with the entered credentials',
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              'Wrong credentials',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Authentication Error',
            );
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
                    child: Image.asset('assets/image_01.png')),
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
                      children: [
                        Image.asset('assets/logo.png'),
                        Text('LOGO',
                            style: TextStyle(
                                fontFamily: "Poppins-Bold",
                                fontSize: 25,
                                color: theme.textTheme.headlineLarge?.color,
                                fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
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
                                'Login',
                                style: theme.textTheme.headlineMedium,
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Text(
                                'Email',
                                style: theme.textTheme.labelLarge,
                              ),
                              TextField(
                                  controller: _username,
                                  decoration: InputDecoration(
                                    hintText: "Enter your email",
                                    labelText: 'Email',
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
                                'Password',
                                style: theme.textTheme.labelLarge,
                              ),
                              TextField(
                                  obscureText: true,
                                  controller: _password,
                                  decoration: InputDecoration(
                                    hintText: "Enter your email",
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
                                      "Forgot Password?",
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
                            'Remember me',
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
                              child: const Center(
                                child: Text("SIGNIN",
                                    style: TextStyle(
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
                        'Social Login',
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
                        onPressed: () {},
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
                      const Text(
                        "New User? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
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
                        child: const Text("SignUp",
                            style: TextStyle(
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
