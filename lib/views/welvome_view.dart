import 'package:flutter/material.dart';
import 'package:flutter_course/custom_icon.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_course/views/register_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                                  return LoginView();
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
