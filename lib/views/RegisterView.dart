import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/CustomIcon.dart';
import 'package:flutter_course/firebase_options.dart';
import 'package:flutter_course/Utilities.dart';
import 'package:flutter_course/views/LoginView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //late => promise that the variable will be assigned with value later
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _confirmPassword;
  final _registerKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.only(
                top: 20.0, bottom: 20, left: 10, right: 10),
            child: Form(
              key: _registerKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Sign Up', style: theme.textTheme.headlineLarge),
                  Text(
                    'Create Your account for free',
                    style: theme.textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter value';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      enableSuggestions: false,
                      controller: _email,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2, color: theme.secondaryHeaderColor)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 3, color: theme.primaryColorLight),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 3, color: theme.errorColor),
                          ),
                          hintText: 'Enter your email here',
                          labelText: 'Email',
                          prefixIcon: const Icon(
                            Icons.account_circle,
                          )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter value';
                        }
                        return null;
                      },
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _password,
                      decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 3, color: theme.errorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2, color: theme.secondaryHeaderColor)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 3, color: theme.primaryColorLight),
                          ),
                          hintText: 'Enter your password here',
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.password)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value != _password.text) {
                          return 'The passwords do not matched';
                        } else if (value?.isEmpty ?? true) {
                          return 'Please enter value';
                        }
                        return null;
                      },
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      controller: _confirmPassword,
                      decoration: InputDecoration(
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide:
                                BorderSide(width: 3, color: theme.errorColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                  width: 2, color: theme.secondaryHeaderColor)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                width: 3, color: theme.primaryColorLight),
                          ),
                          hintText: 'Enter your password again',
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.check)),
                    ),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shadowColor: theme.shadowColor,
                        backgroundColor: Colors.transparent),
                    onPressed: () async {
                      if (_registerKey.currentState!.validate()) {
                        try {
                          final email = _email.text;
                          final password = _password.text;
                          final userCredential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: email, password: password);
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'weak-password') {
                            showAlertDialog('weak password', 'Error', context,
                                () => Navigator.pop(context));
                          } else if (e.code == 'email-already-in-use') {
                            showAlertDialog('email is already use', 'Error',
                                context, () => Navigator.pop(context));
                          } else if (e.code == 'invalid-email') {
                            showAlertDialog('Invalid email entered', 'Error',
                                context, () => Navigator.pop(context));
                          }
                        }
                      }
                    },
                    child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              CustomColor.kPrimaryColor,
                              CustomColor.kSecondaryColor
                            ]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: CustomColor.kSecondaryColor
                                      .withOpacity(.3),
                                  offset: const Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Container(
                            alignment: Alignment.center,
                            width: 0.8.sw,
                            height: ScreenUtil().setHeight(150),
                            child: const Text(
                              'Register',
                              style: TextStyle(fontSize: 25),
                            ))),
                  ),
                  SizedBox(
                    height: ScreenUtil().setHeight(100),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "Already Have an Account? ",
                        style: TextStyle(fontFamily: "Poppins-Medium"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          final page = const LoginPage();
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => page));
                        },
                        child: const Text("Login",
                            style: TextStyle(
                                color: Color(0xFF5d74e3),
                                fontFamily: "Poppins-Bold")),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
