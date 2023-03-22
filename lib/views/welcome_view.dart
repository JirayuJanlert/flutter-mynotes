import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:flutter_course/extensions/buildcontext/loc.dart';
import 'package:flutter_course/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_course/views/login_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SizedBox(
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
                  context.loc.welcome_screen_prompt,
                  style: theme.textTheme.headlineMedium,
                ),
                SizedBox(height: ScreenUtil().setHeight(20)),
                Container(
                    height: 0.5.sh,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 60),
                    child: SvgPicture.asset(
                      'assets/image_03.svg',
                      fit: BoxFit.fitHeight,
                    )),
                Row(
                  children: [
                    const Spacer(),
                    Expanded(
                      flex: 8,
                      child: Column(children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                shadowColor: theme.shadowColor,
                                backgroundColor: CustomColor.kSecondaryColor
                                    .withOpacity(0.8),
                                shape: const StadiumBorder(),
                                maximumSize: const Size(double.infinity, 56),
                                minimumSize: const Size(double.infinity, 56)),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) {
                                    return BlocProvider.value(
                                      value: BlocProvider.of<AuthBloc>(context),
                                      child: const LoginView(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: Text(context.loc.login_capital)),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              shadowColor: theme.shadowColor,
                              backgroundColor: Colors.black26,
                              shape: const StadiumBorder(),
                              maximumSize: const Size(double.infinity, 56),
                              minimumSize: const Size(double.infinity, 56),
                            ),
                            onPressed: () {},
                            child: Text(
                              context.loc.signup_capital,
                              style: theme.textTheme.labelLarge,
                            )),
                      ]),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
