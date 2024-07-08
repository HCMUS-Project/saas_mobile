import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/provider/setting_provider.dart';
import 'package:mobilefinalhcmus/widgets/custom_textfield.dart';
import 'package:mobilefinalhcmus/widgets/password_textfield.dart';
import 'package:mobilefinalhcmus/widgets/verify_opt.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: const Column(
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
                  padding: const EdgeInsets.only(bottom: 0),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                                validator: (value) =>
                                    provider.usernameValidator(value, context),
                                controller: usernameController,
                                hintText: AppLocalizations.of(context)!.translate('username')!),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                                validator: (value) =>
                                    provider.emailValidator(value, context),
                                controller: emailController,
                                hintText: "Email"),
                            const SizedBox(
                              height: 10,
                            ),
                            PasswordFielddWidget(
                              validator: (value) => 
                                  provider.passwordValidator(value, context),
                              controller: passwordController,
                            ),
                            const SizedBox(
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
                              selectorConfig: const SelectorConfig(
                                selectorType: PhoneInputSelectorType.DROPDOWN,
                              ),
                              hintText: AppLocalizations.of(context)!.translate('phoneNumber')!,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.translate('forgotPassword')!,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ),
                            const SizedBox(
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
                                              .showSnackBar(const SnackBar(
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
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          AppLocalizations.of(context)!.translate('register')!,
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
