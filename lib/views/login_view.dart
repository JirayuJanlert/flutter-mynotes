import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/utilities.dart';
import 'package:flutter_course/custom_icon.dart';
import 'package:flutter_course/views/register_view.dart';
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
    // TODO: implement initState
    _username = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Stack(fit: StackFit.expand, children: <Widget>[
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
                              fontSize: 32,
                              color: theme.textTheme.headlineLarge?.color,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
                const SizedBox(height: 80),
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
                        height: ScreenUtil().setHeight(980),
                        child: Column(
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
                                      color: theme.hintColor), //hint text style
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Password',
                              style: theme.textTheme.labelLarge,
                            ),
                            TextField(
                                controller: _password,
                                decoration: InputDecoration(
                                  hintText: "Enter your email",
                                  labelStyle: theme.textTheme.labelLarge,
                                  prefixIcon: const Icon(Icons.password),
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: theme.hintColor), //hint text style
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: theme.accentColor, fontSize: 20),
                                )
                              ],
                            )
                          ],
                        )),
                  ),
                ),
                const SizedBox(height: 30),
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
                      width: 150,
                      height: 80,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            CustomColor.kPrimaryColor,
                            CustomColor.kSecondaryColor
                          ]),
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: [
                            BoxShadow(
                                color: const Color(0xFF6078ea).withOpacity(.3),
                                offset: const Offset(0.0, 8.0),
                                blurRadius: 8.0)
                          ]),
                      child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              final email = _username.text;
                              final password = _password.text;
                              try {
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .signInWithEmailAndPassword(
                                        email: email, password: password);
                              } on FirebaseAuthException catch (exception) {
                                if (exception.code == 'user-not-found') {
                                  showAlertDialog('User is not found', 'Error',
                                      context, () => Navigator.pop(context));
                                } else if (exception.code == 'wrong-password') {
                                  showAlertDialog('Password is wrong', 'Error',
                                      context, () => Navigator.pop(context));
                                }
                              }
                            },
                            child: const Center(
                              child: Text("SIGNIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Poppins-Bold",
                                      fontSize: 18,
                                      letterSpacing: 1.0)),
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
                        final page = const RegisterView();

                        Navigator.pushNamedAndRemoveUntil(
                            context, '/register', (route) => false);

                        // Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => page),
                        //     (route) => false);
                      },
                      child: const Text("SignUp",
                          style: TextStyle(
                              color: Color(0xFF5d74e3),
                              fontFamily: "Poppins-Bold")),
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
    );
  }
}
