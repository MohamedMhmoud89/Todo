import 'package:flutter/material.dart';
import 'package:todo/ui/login/login_screen.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = 'splash_screen';

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 4),
      () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      },
    );
    return Scaffold(
      backgroundColor: Color(0xffDFECDB),
      body: Image.asset(
        'assets/images/splash.png',
        fit: BoxFit.fill,
      ),
    );
  }
}
