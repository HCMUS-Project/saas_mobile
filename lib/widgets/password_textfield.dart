import 'package:flutter/material.dart';

class PasswordFielddWidget extends StatefulWidget {
   PasswordFielddWidget({
    super.key,
    this.controller,
    this.validator
  });
  TextEditingController? controller;
  final FormFieldValidator? validator;
  @override
  State<PasswordFielddWidget> createState() => _PasswordFielddWidgetState();
}

class _PasswordFielddWidgetState extends State<PasswordFielddWidget> {
  bool passwordVisible = false;
  
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Theme.of(context).colorScheme.secondary,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: widget.controller,
      obscureText: passwordVisible,
      decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              // borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid)
              borderSide: BorderSide.none
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(30))),
          hintText: "Password",
          filled: true,
          fillColor: Colors.grey.shade200,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                passwordVisible = !passwordVisible;
              });
            },
            icon:
                Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          )),
    );
  }
}