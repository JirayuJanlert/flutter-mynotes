import 'package:flutter/material.dart';
import 'package:flutter_course/constant/custom.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

Widget customLoadingIndicator() => Center(
        child: LoadingAnimationWidget.twistingDots(
      leftDotColor: const Color(0xFF1A1A3F),
      rightDotColor: CustomColor.kSecondaryColor,
      size: 200,
    ));
