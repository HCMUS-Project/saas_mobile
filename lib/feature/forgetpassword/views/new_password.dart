import 'package:flutter/material.dart';

class CreatePasswordPage extends StatelessWidget {
  CreatePasswordPage({super.key});
  FocusNode myFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: const Text(
            "Create New Password",
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: const Image(image: AssetImage("assets/images/key.png")),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  Text("Your New Password Must Be Differnt",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  Text("from Previously Used Password",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 35,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "New Password",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                        ),
                        const TextField(
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Confirm Password",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.bold)),
                        const TextField(
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey))),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: size.width / 1.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFCE01)),
                      child: Text(
                        "Save",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
