import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_course/CustomIcon.dart';
import 'package:flutter_course/views/LoginView.dart';
import 'package:flutter_course/views/RegisterView.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Demo',
    theme: ThemeData(
      textTheme:
          const TextTheme(headlineLarge: TextStyle(color: Color(0xFF6078ea))),
      accentColor: Color(0xFF5d74e3),
      fontFamily: "Poppins-Medium",
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(1080, 2340));
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                final emailVerified = user?.emailVerified ?? false;
                if (emailVerified) {
                  print('You are a verified user');
                } else {
                  print('You need to verify your email first');
                }
                return WelcomeScreen();
              default:
                return Center(
                    child: LoadingAnimationWidget.twistingDots(
                  leftDotColor: const Color(0xFF1A1A3F),
                  rightDotColor: Theme.of(context).accentColor,
                  size: 200,
                ));
            }
          }),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(bottom: 0, child: Image.asset('assets/image_02.png')),
          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to myNote',
                style: theme.textTheme.headlineMedium,
              ),
              SizedBox(height: ScreenUtil().setHeight(20)),
              Container(
                  height: 0.5.sh,
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 60),
                  child: SvgPicture.asset(
                    'assets/image_03.svg',
                    fit: BoxFit.fitHeight,
                  )),
              Row(
                children: [
                  Spacer(),
                  Expanded(
                    flex: 8,
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shadowColor: theme.shadowColor,
                              backgroundColor:
                                  CustomColor.kSecondaryColor.withOpacity(0.8),
                              shape: const StadiumBorder(),
                              maximumSize: Size(double.infinity, 56),
                              minimumSize: Size(double.infinity, 56)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return LoginPage();
                                },
                              ),
                            );
                          },
                          child: Text('LOGIN')),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            shadowColor: theme.shadowColor,
                            backgroundColor: Colors.black26,
                            shape: const StadiumBorder(),
                            maximumSize: Size(double.infinity, 56),
                            minimumSize: Size(double.infinity, 56),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return RegisterView();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'SIGNUP',
                            style: theme.textTheme.labelLarge,
                          )),
                    ]),
                  ),
                  Spacer(),
                ],
              ),
            ],
          ))
        ],
      ),
    );
  }
}

//#4fd4da