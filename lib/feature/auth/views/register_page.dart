import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/provider/setting_provider.dart';
import 'package:mobilefinalhcmus/widgets/custom_textfield.dart';
import 'package:mobilefinalhcmus/widgets/password_textfield.dart';
import 'package:mobilefinalhcmus/widgets/verify_opt.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController usernameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  bool? checkPhoneNumber = false;

  PhoneNumber number = PhoneNumber(isoCode: 'VN');
  final formKey = GlobalKey<FormState>();

  final provider = SettingsProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.addListener(_updateCountryCode);
  }

  void _updateCountryCode() async {
    String input = phoneController.text;
    // Kiểm tra nếu input bắt đầu bằng dấu +
    if (input.startsWith('+') ) {
      try {
        print("phone number ${input.substring(0, 3)}");
        PhoneNumber number = await PhoneNumber.getRegionInfoFromPhoneNumber(
            "${input}0000");

        print(number);
        setState(() {
          this.number = number;
        });
      } catch (e) {
        print('Không tìm thấy mã quốc gia: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161D3A),
      appBar: AppBar(
       
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: constraints.maxWidth,
                    child: Column(
                      children: [
                        Text(
                          "Register",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  padding: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                                validator: (value) =>
                                    provider.usernameValidator(value),
                                controller: usernameController,
                                hintText: "Username"),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                                validator: (value) =>
                                    provider.emailValidator(value),
                                controller: emailController,
                                hintText: "Email"),
                            SizedBox(
                              height: 10,
                            ),
                            PasswordFielddWidget(
                              validator: (value) =>
                                  provider.passwordValidator(value),
                              controller: passwordController,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InternationalPhoneNumberInput(
                              initialValue: number,
                              validator: (value) =>
                                  provider.phoneValidator(value!),
                              textFieldController: phoneController,
                              onFieldSubmitted: (value) {},
                              onInputChanged: (value) async {},
                              onInputValidated: (value) {
                                if (value) {
                                  setState(() {
                                    checkPhoneNumber = true;
                                  });
                                } else {
                                  setState(() {
                                    checkPhoneNumber = false;
                                  });
                                }
                              },
                              keyboardType: TextInputType.phone,
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DROPDOWN,
                              ),
                              hintText: "Phone number",
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Forgot Password?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      fixedSize:
                                          Size(constraints.maxWidth / 2, 50)),
                                  onPressed: () async {
                                    print(checkPhoneNumber! &&
                                        formKey.currentState!.validate());
                                    if (checkPhoneNumber! &&
                                        formKey.currentState!.validate()) {
                                      await context
                                          .read<AuthenticateProvider>()
                                          .registerWithPassword(
                                              domain: context
                                                  .read<AuthenticateProvider>()
                                                  .domain!,
                                              phone:
                                                  phoneController.text.trim(),
                                              username: usernameController.text
                                                  .trim(),
                                              email:
                                                  emailController.text.trim(),
                                              password: passwordController.text
                                                  .trim());
                                      final errorMessage = context
                                          .read<AuthenticateProvider>()
                                          .httpResponseFlutter
                                          .errorMessage;
                                      print(errorMessage);
                                      if (errorMessage != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text(errorMessage)));
                                      } else {
                                        final resResult = context
                                            .read<AuthenticateProvider>()
                                            .httpResponseFlutter
                                            .result;
                                        if (resResult != null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text(
                                                      resResult['result'])));

                                          final result = context
                                              .read<AuthenticateProvider>()
                                              .httpResponseFlutter
                                              .result;
                                          if (result?['result'] != null) {
                                            Navigator.of(context)
                                                .push(MaterialPageRoute(
                                              builder: (context) {
                                                return VerifyOtp(
                                                  email: emailController.text,
                                                  style: "sign-up",
                                                );
                                              },
                                            ));
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content: Text("Error")));
                                        }
                                      }
                                    }
                                  },
                                  child: context
                                          .watch<AuthenticateProvider>()
                                          .httpResponseFlutter
                                          .isLoading!
                                      ? CircularProgressIndicator()
                                      : Text(
                                          "Register",
                                          style: TextStyle(color: Colors.white),
                                        )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
