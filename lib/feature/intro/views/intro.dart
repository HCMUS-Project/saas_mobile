import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/main_page.dart';
import 'package:mobilefinalhcmus/feature/tenant/views/tenant_page.dart';
import 'package:mobilefinalhcmus/main.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class IntroPage extends StatefulWidget {
  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  

  Timer? trasitionTimer;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    trasitionTimer = Timer(Duration(seconds: 3), () {
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
                    decoration: BoxDecoration(color: Color(0xFF161D3A)),
                    child: Container(
                      decoration: BoxDecoration(
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
                    decoration: BoxDecoration(color: Colors.white),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF161D3A),
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(60))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Text("Welcome to our intuitive booking",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                                textAlign: TextAlign.center),
                            Text("platform where convenience meets efficiency",
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
