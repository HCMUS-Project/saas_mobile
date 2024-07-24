import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/forgetpassword/views/verifi_password.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/widgets/custom_textfield.dart';
import 'package:mobilefinalhcmus/widgets/password_textfield.dart';
import 'package:provider/provider.dart';

class ForgetPasswordPage extends StatefulWidget {
  ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  FocusNode myFocusNode = FocusNode();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController= TextEditingController();

  TextEditingController confirmPasswordController =  TextEditingController();

  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "Forget Password",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
            top: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Container(
            child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: 250,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 250, 206),
                        shape: BoxShape.circle),
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: const Image(
                          image: AssetImage("assets/images/lock.png")),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "Please Enter Your Email Address To",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Recieve a Verification Cord.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  CustomTextField(hintText: AppLocalizations.of(context)!.translate('email')!
                  ,controller: emailController,),
                  SizedBox(
                    height: 10,
                  ),
                  PasswordFielddWidget(
                    controller: passwordController,
                    hintText: "${(AppLocalizations.of(context)!.translate('enter')!)} ${AppLocalizations.of(context)!.translate('newPassword')!}",
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  PasswordFielddWidget(
                    controller: confirmPasswordController,
                    hintText: "${(AppLocalizations.of(context)!.translate('enter')!)} ${AppLocalizations.of(context)!.translate('confirmPassword')!}",
                  ),
                  
                  if (errorMessage != null)
                  Text(errorMessage!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red
                  ),),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFCE01)),
                          child: const Text(
                            "Send",
                            style: TextStyle(color: Colors.black),
                          ),
                          onPressed: () async {
                            await context
                                .read<AuthenticateProvider>()
                                .sendMailForgotPassword(
                                    domain: context
                                        .read<AuthenticateProvider>()
                                        .domain!,
                                    email: emailController.text);
                            if (passwordController.text == confirmPasswordController.text){
                              Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return VerifyPasswordPage(
                                  password: passwordController.text,
                                  email: emailController.text,
                                );
                              },
                            ));
                            }else{
                              setState(() {
                                errorMessage = "password is not match";
                              });
                            }
                            
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
