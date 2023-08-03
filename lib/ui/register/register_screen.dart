import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/database/model/user.dart' as MyUser;
import 'package:todo/database/my_database.dart';
import 'package:todo/providers/auth_provider.dart';
import 'package:todo/ui/components/custom_form_feild.dart';
import 'package:todo/ui/dialog_utils.dart';
import 'package:todo/ui/login/login_screen.dart';
import 'package:todo/validation_utils.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'Register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var formkey = GlobalKey<FormState>();

  var nameController = TextEditingController(text: '');

  var emailController = TextEditingController(text: '');

  var passwordController = TextEditingController(text: '');

  var passwordConfirmationController = TextEditingController(text: '');

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
          title: Text('Create Account'),
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
                    label: "Full Name",
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter full name';
                      }
                    },
                    controller: nameController,
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
                  CustomFormField(
                    label: "Password-Confirmation",
                    isPassword: true,
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please enter Password-Confirmation';
                      }
                      if (passwordController.text != text) {
                        return "Password doesn't match";
                      }
                    },
                    controller: passwordConfirmationController,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      register();
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 7, right: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text('Register'), Icon(Icons.arrow_forward)],
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
                            context, LoginScreen.routeName);
                      },
                      child: Text('Already have account?'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FirebaseAuth authService = FirebaseAuth.instance;

  void register() async {
    if (formkey.currentState?.validate() == false) {
      return;
    }
    DialogUtils.showLoadingDialog(context, "Please wait...");
    try {
      var result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      var myUser = MyUser.User(
        id: result.user?.uid,
        name: nameController.text,
        email: emailController.text,
      );
      await MyDataBase.addUser(myUser);
      var authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.updateUser(myUser);
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, 'Register is successful',
          postActionName: 'Login', postAction: () {
        Navigator.pushReplacementNamed(context, LoginScreen.routeName);
      });
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Something went wrong';
      if (e.code == 'weak-password') {
        errorMessage = 'The password provided is too weak.';
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(context, errorMessage, postActionName: 'Ok');
      } else if (e.code == 'email-already-in-use') {
        errorMessage = 'The account already exists for that email.';
        DialogUtils.hideDialog(context);
        DialogUtils.showMessage(
          context,
          errorMessage,
          postActionName: 'Ok',
        );
      }
    } catch (e) {
      String errorMessage = 'Something went wrong';
      errorMessage = 'Something went wrong';
      DialogUtils.hideDialog(context);
      DialogUtils.showMessage(context, errorMessage);
    }
  }
}
