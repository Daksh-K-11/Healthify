import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.readOnly = false,
    this.onTap,
    this.keyBoardType,
    super.key,
  });

  final String hintText;
  final TextEditingController? controller;
  final bool isObscureText;
  final bool readOnly;
  final TextInputType? keyBoardType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      readOnly: readOnly,
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      keyboardType: keyBoardType,
      validator: (val) {
        if (val!.trim().isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
