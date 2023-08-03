import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/edit_task/edit_task.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/login/login_screen.dart';
import 'package:todo/ui/register/register_screen.dart';
import 'package:todo/ui/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
      create: (buildContext) => AuthProvider(), child: MyApplication()));
}

class MyApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => SplashScreen(),
        LoginScreen.routeName: (_) => LoginScreen(),
        RegisterScreen.routeName: (_) => RegisterScreen(),
        HomeScreen.routeName: (_) => HomeScreen(),
        EditTask.routeName: (_) => EditTask()
      },
      theme: ThemeData(
          textTheme: TextTheme(
              headlineMedium: TextStyle(
                  fontSize: 20,
                  color: Color(0xff383838),
                  fontWeight: FontWeight.bold)),
          primaryColor: Color(0xff5D9CEC),
          canvasColor: Color(0xffFFFFFF),
          appBarTheme: AppBarTheme(
              backgroundColor: Color(0xff5D9CEC),
              elevation: 0,
              centerTitle: true,
              titleTextStyle:
                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          scaffoldBackgroundColor: Color(0xffDFECDB),
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
              backgroundColor: Colors.transparent, elevation: 0)),
    );
  }
}
