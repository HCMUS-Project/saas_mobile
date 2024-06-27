import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/provider/setting_provider.dart';
import 'package:mobilefinalhcmus/widgets/custom_textfield.dart';
import 'package:mobilefinalhcmus/widgets/password_textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final provider = SettingsProvider();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // Size size = MediaQuery.of(context).size;
    // print(context.read<AuthenticateProvider>().domain);
    final domain = dotenv.env['DOMAIN'];
    print(domain);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed('/auth/signup');
              },
              child: const Text(
                "Register",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: const Column(
                      children: [
                        Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.transparent,
                          maxRadius: 65,
                          child: Image(
                              image: AssetImage("assets/images/logo_0.png")),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
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
                                    provider.emailValidator(value),
                                controller: emailController,
                                hintText: "Username"),
                            const SizedBox(
                              height: 10,
                            ),
                            PasswordFielddWidget(
                              validator: (value) =>
                                  provider.passwordValidator(value),
                              controller: passController,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context)
                                        .pushNamed("/forgetpassword");
                                  },
                                  child: const Text(
                                    "Forgot Password?",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                style: Theme.of(context)
                                    .elevatedButtonTheme
                                    .style
                                    ?.copyWith(
                                        fixedSize: MaterialStatePropertyAll(
                                            Size(
                                                constraints.maxWidth / 2, 50))),
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    print("ewqewq");
                                    await context
                                        .read<AuthenticateProvider>()
                                        .SignIn(
                                            domain: domain!,
                                            email: emailController.text,
                                            password: passController.text);
                                    final error = context
                                        .read<AuthenticateProvider>()
                                        .httpResponseFlutter
                                        .errorMessage;
                                    if (error != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(error)));
                                    } else {
                                      final data = context
                                          .read<AuthenticateProvider>()
                                          .httpResponseFlutter
                                          .result;
                                      if (data != null) {
                                        print(context
                                            .read<AuthenticateProvider>()
                                            .token);
                                        print(context
                                            .read<AuthenticateProvider>()
                                            .refreshToken);
                                        context.read<HomeProvider>().setIndex =
                                            0;
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/home', (route) => false);
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text("Error")));
                                      }
                                    }
                                  }
                                },
                                child: Consumer<AuthenticateProvider>(
                                  builder: (context, value, child) {
                                    final isLoading = context.select((AuthenticateProvider provider) => provider.httpResponseFlutter.isLoading);
                                    return isLoading! ? CircularProgressIndicator() :const Text(
                                    "Sign In",
                                    style: TextStyle(color: Colors.white),
                                  );
                                  },
                    
                                )),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 0.5),
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: SvgPicture.asset(
                                              "assets/images/google.svg",
                                              height: 24,
                                              width: 24,
                                            ),
                                            title:
                                                const Text("Continue with Facebook"),
                                            trailing: const Icon(
                                                Icons.arrow_forward_outlined),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              elevation: 0.5),
                                          onPressed: () {},
                                          child: ListTile(
                                            leading: SvgPicture.asset(
                                              "assets/images/facebook.svg",
                                              height: 24,
                                              width: 24,
                                            ),
                                            title:
                                                const Text("Continue with Facebook"),
                                            trailing: const Icon(
                                                Icons.arrow_forward_outlined),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
