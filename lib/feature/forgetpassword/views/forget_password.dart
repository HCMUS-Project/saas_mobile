import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgetPasswordPage extends StatelessWidget {
  ForgetPasswordPage({super.key});
  FocusNode myFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
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
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Container(
                  height: 250,
                  width: 250,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 250, 206),
                      shape: BoxShape.circle),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                       shape: BoxShape.circle),
                    child: Image(image: AssetImage("assets/images/lock.png")),
                  ),
                ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Please Enter Your Email Address To",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Recieve a Verification Cord.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelStyle: TextStyle(
                            color: myFocusNode.hasFocus
                                ? Colors.blue
                                : Colors.black),
                        label: Text("Email Address"),
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
                      child: Container(
                        width: size.width * 0.7,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFCE01)),
                          child: Text(
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
