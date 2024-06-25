import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

final defaultPinTheme = PinTheme(
  width: 56,
  height: 56,
  textStyle: const TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600),
  decoration: BoxDecoration(
    color: const Color(0xFFFFFBEB),
    border: const Border(bottom: BorderSide(color: Colors.yellow)),
    borderRadius: BorderRadius.circular(20),
  ),
);

final focusedPinTheme = defaultPinTheme.copyDecorationWith(
  color: const Color(0xFFFFFBEB),
  border: const Border(bottom: BorderSide(
    width: 2,
    color: Colors.yellow)),
  borderRadius: BorderRadius.circular(8),
);

final submittedPinTheme = defaultPinTheme.copyWith(
  decoration: defaultPinTheme.decoration?.copyWith(
    color: const Color(0xFFFFFBEB),
    border: const Border(bottom: BorderSide(
      width: 2,
      color: Colors.yellow)),
  ),
);

class PinWidget extends StatelessWidget {
  String? Function()? validator;
  String? validateValue;
  String? email;
  PinWidget(
    {
      super.key,
      this.validator,
      this.validateValue,
      this.email
    }
  );

  @override
  Widget build(BuildContext context) {
    return Pinput(
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      keyboardType: TextInputType.number,
      length: 6,
      submittedPinTheme: submittedPinTheme,
      // validator: (value) {
      //   return value == validateValue ? "correct" : "opt is invalid";
      // },
      onCompleted: (value) async{
        await context.read<AuthenticateProvider>().verifyOtp(domain: context.read<AuthenticateProvider>().domain!, email: email!, otp: value);
        final errorMessage = context.read<AuthenticateProvider>().httpResponseFlutter.errorMessage;
        if (errorMessage != null){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(errorMessage)
            )
          );
        }else{
          validateValue = context.read<AuthenticateProvider>().httpResponseFlutter.result?['result'];
          // validator!();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) {
            return LoginPage();
          },), (route) => false);
        }
      },
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
    );
  }
}
