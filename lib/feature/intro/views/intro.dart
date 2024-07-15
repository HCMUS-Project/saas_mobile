import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/main.dart';
import 'package:mobilefinalhcmus/provider/theme_provider.dart';
import 'package:mobilefinalhcmus/widgets/loading_widget.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  late ThemeProvider themeProvider;
  String? initRoute;
  Timer? trasitionTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    themeProvider = context.read<ThemeProvider>();

    initRoute = themeProvider.initialRoute;
  }

  @override
  void didUpdateWidget(covariant IntroPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    print(initRoute);
    print(themeProvider.initialRoute);
    if (initRoute != themeProvider.initialRoute) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) async {
          if (context.read<AuthenticateProvider>().token != null && context.read<AuthenticateProvider>().refreshToken != null) {
            print(context.read<AuthenticateProvider>().token);
            print(context.read<AuthenticateProvider>().refreshToken);
            await checkToken(context);
          }
          Navigator.pushReplacementNamed(context, '/home');

        },
      );
    }
  }

  Future<void> checkToken(BuildContext context) async {
    print("check token");
    final controller = LoadingWidget(context);
    //overlay loading widget
    await context.read<AuthenticateProvider>().refreshTokenFunc(
        refreshToken: context.read<AuthenticateProvider>().refreshToken!);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    trasitionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) => Container(
          child: Column(
            children: [
              Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xFF161D3A)),
                    child: Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/intro_bg.jpg")),
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(60))),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: Container(
                    width: constraints.maxWidth,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Color(0xFF161D3A),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Text("Welcome to our intuitive booking",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center),
                            const Text(
                                "platform where convenience meets efficiency",
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 15),
                                textAlign: TextAlign.center),
                            Expanded(
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: Theme.of(context).scaffoldBackgroundColor,
                                        ),
                                        Text(
                                          "Please wait...",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary),
                                        )
                                      ],
                                    )))
                          ],
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
