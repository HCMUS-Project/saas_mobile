import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';

class PasswordFielddWidget extends StatefulWidget {
   PasswordFielddWidget({
    super.key,
    this.controller,
    this.validator,
    this.hintText
  });
  TextEditingController? controller;
  String ? hintText;
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
      cursorColor: Theme.of(context).textTheme.bodyMedium?.color,
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
          hintText: widget.hintText ?? AppLocalizations.of(context)!.translate('loginPassword')!,
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