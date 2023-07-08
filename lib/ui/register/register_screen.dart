import 'package:flutter/material.dart';
import 'package:todo/ui/components/custom_form_feild.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'Register';
  var formkey = GlobalKey<FormState>();

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
                  CustomFormField(label: "Full Name"),
                  CustomFormField(
                      label: "E-Mail",
                      keyboardType: TextInputType.emailAddress),
                  CustomFormField(
                      label: "Phone", keyboardType: TextInputType.phone),
                  CustomFormField(label: "Password", isPassword: true),
                  CustomFormField(label: "Conferm-Password", isPassword: true),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Register'),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8)),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void register() {
    formkey.currentState?.validate();
  }
}
