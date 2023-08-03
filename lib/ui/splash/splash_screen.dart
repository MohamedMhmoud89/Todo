import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = 'splash_screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 4),
      () {
        checkLoggedInUser();
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Image.asset(
          'assets/images/splash.png',
          fit: BoxFit.fill,
          width: 180,
          height: 200,
        ),
      ),
    );
  }

  void checkLoggedInUser() async {
    var authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isUserLoggedInBefore()) {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      return;
    }
    await authProvider.autoLogin();
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }
}
