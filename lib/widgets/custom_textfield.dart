import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.validator

  }); 
  TextEditingController? controller;
  final FormFieldValidator? validator;
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide:  BorderSide.none
        ),
        hintText: hintText,
        fillColor: Colors.grey.shade200,
        filled: true
      ),
    );
  }
}