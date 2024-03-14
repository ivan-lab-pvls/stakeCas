import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:stake_trade/main.dart';
import 'package:stake_trade/pages/home_page.dart';
import 'package:stake_trade/pages/onBoarding_page.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: const Color(0xFF0D2D3A),
      duration: 1000,
      splashIconSize: double.infinity,
      splash: Center(
        child: Image.asset(
          'assets/logo.png',
          height: 200,
          width: 200,
        ),
      ),
      nextScreen: initScreen == 0 || initScreen == null
          ? const OnBoardingPage()
          : const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.fade,
    );
  }
}
