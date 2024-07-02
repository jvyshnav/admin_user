import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {super.key,
      required this.hintText,
      this.obscureText = false,
      required this.controller});

  final String hintText;
  final bool obscureText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(

        obscureText: obscureText,
        controller: controller,
        decoration:
            InputDecoration(border: const OutlineInputBorder(), hintText: hintText),
      ),
    );
  }
}
