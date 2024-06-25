import 'dart:async';

import 'package:flutter/material.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  

  Timer? trasitionTimer;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    trasitionTimer = Timer(const Duration(seconds: 3), () {
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) {
      //     return TenantPage();
      //   },
      // ));
      Navigator.pushReplacementNamed(context, '/home');
    });
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
                            const Text("platform where convenience meets efficiency",
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
