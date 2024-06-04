import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/widgets/pin_widget.dart';
import 'package:mobilefinalhcmus/widgets/verify_opt.dart';

class VerifyPasswordPage extends StatelessWidget {
  VerifyPasswordPage(
    {
      super.key,
      this.email
    });
  String? email;
  @override
  Widget build(BuildContext context) {
    return VerifyOtp(
      email: email!,
      style: "forget-password",
    );
  }
}
