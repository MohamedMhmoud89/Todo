import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  bool isPassword;

  CustomFormField(
      {required this.label,
      this.isPassword = false,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
    );
  }
}
