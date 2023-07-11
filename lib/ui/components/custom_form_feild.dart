import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?);

class CustomFormField extends StatelessWidget {
  String label;
  TextInputType keyboardType;
  bool isPassword;
  MyValidator validator;
  TextEditingController controller;

  CustomFormField(
      {required this.controller,
      required this.label,
      this.isPassword = false,
      required this.validator,
      this.keyboardType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
      validator: validator,
      controller: controller,
    );
  }
}
