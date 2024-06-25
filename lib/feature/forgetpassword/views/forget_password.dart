import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});
  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          "Forget Password",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
                    decoration: const BoxDecoration(
                       shape: BoxShape.circle),
                    child: const Image(image: AssetImage("assets/images/lock.png")),
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
                  TextField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.black),
                        label: const Text("Email Address"),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        border: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400))),
                  ),
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
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed("/forgetpassword/verify");
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
