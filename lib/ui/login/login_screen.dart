import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/my_database.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/components/custom_form_feild.dart';
import 'package:todo/ui/dialog_utils.dart';
import 'package:todo/ui/home/home_screen.dart';
import 'package:todo/ui/register/register_screen.dart';
import 'package:todo/validation_utils.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var formkey = GlobalKey<FormState>();

  var emailController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xffDFECDB),
          image: DecorationImage(
              alignment: Alignment(0, 100),
              image: AssetImage('assets/images/auth_pattern.png'),
              fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Login'),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  CustomFormField(
                    label: "E-Mail",
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter email';
                      }
                      if (!ValidationUtils.isValidEmail(text)) {
                        return 'Please enter a valid email';
                      }
                    },
                    controller: emailController,
                  ),
                  CustomFormField(
                    label: "Password",
                    isPassword: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter password';
                      }
                      if (text!.length < 8) {
                        return 'password should be at least 8 chars';
                      }
                    },
                    controller: passwordController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Login();
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Login'), Icon(Icons.arrow_forward)],
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, RegisterScreen.routeName);
                      },
                      child: Text('Or Create My Account'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void Login() async {
    if (formkey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Please wait...");
    try {
      var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      var user = await MyDataBase.readUser(result.user?.uid ?? "");
      DialogUtils.hideDialog(context);
      if (user == null) {
        print('noooooooooooo');
        DialogUtils.showMessage(context, "error. can't find user in db");
        return;
      }
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(user);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      // DialogUtils.showMessage(
      //   context,
      //   'Login Successful',
      //   postActionName: 'Ok',
      //   postAction: () {
      //     Navigator.pushReplacementNamed(context, HomeScreen.routeName);
      //   },
      //   dismissible: false,
      // );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, errorMessage, postActionName: 'Ok');
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password.';
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, errorMessage, postActionName: 'Ok');
      }
    } catch (e) {
      String errorMessage = 'Something went wrong';
      errorMessage = 'Something went wrong';
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, errorMessage,
          postActionName: 'Ok', negActionName: 'Try Again', negAction: () {
        Login();
      });
    }
  }
}
