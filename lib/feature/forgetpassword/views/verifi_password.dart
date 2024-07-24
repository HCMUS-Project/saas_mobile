import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/widgets/verify_opt.dart';

class VerifyPasswordPage extends StatelessWidget {
  VerifyPasswordPage(
    {
      super.key,
      this.email,
      this.password
    });
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return VerifyOtp(
      email: email!,
      password: password,
      style: "forget-password",
    );
  }
}
