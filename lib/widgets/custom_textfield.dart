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
      cursorColor: Theme.of(context).colorScheme.secondary,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide.none
          // borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid)
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