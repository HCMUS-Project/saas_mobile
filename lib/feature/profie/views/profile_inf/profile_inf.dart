import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileInfor extends StatefulWidget {
  ProfileInfor({super.key});

  @override
  State<ProfileInfor> createState() => _ProfileInforState();
}

class _ProfileInforState extends State<ProfileInfor> {
  bool editStatus = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final profile = context.watch<AuthenticateProvider>().profile;
    usernameController.text = profile?['username'];
    addressController.text = profile?['address'];
    emailController.text = profile?['email'];
    phoneController.text = profile?['phone'];
    ageController.text = (profile?['age']).toString();

    return Scaffold(
      
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text("Profile",style: Theme.of(context).textTheme.titleLarge,),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundImage: AssetImage("assets/images/avatar.png"),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                fixedSize: Size(100, 15)),
                            onPressed: () {
                              setState(() {
                                editStatus = true;
                              });
                            },
                            child: Text("Edit"))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 6,
                child: Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                      child: Column(
                    children: [
                      ShowInf(
                        controller: usernameController,
                        editStatus: editStatus,
                        title: "Name",
                        value: profile?['username'],
                      ),
                      ShowInf(
                        controller: emailController,
                        editStatus: editStatus,
                        title: "Email",
                        value: profile?['email'],
                      ),
                      ShowInf(
                        controller: addressController,
                        editStatus: editStatus,
                        title: "Address",
                        value: profile?['address'],
                      ),
                      ShowInf(
                        controller: ageController,
                        editStatus: editStatus,
                        title: "Age",
                        value: (profile?['age']).toString(),
                      ),
                      ShowInf(
                        title: "Domain",
                        value: profile?['domain'],
                      ),
                    ],
                  )),
                )),
            if (editStatus)
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(fixedSize: Size(150, 15)),
                    onPressed: () async {
                      print(ageController.text);
                      await context
                          .read<AuthenticateProvider>()
                          .updateProfile(
                              token:
                                  context.read<AuthenticateProvider>().token!,
                              address: addressController.text,
                              username: usernameController.text,
                              age: int.parse(ageController.text),
                              name: " ",
                              gender: " ",
                              phone: phoneController.text);
                      final error = context
                          .read<AuthenticateProvider>()
                          .httpResponseFlutter
                          .errorMessage;
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(error)));
                      }else{
                        

                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors.green,
                                                content: Text(
                                                    "success")));
                        editStatus = false;
                      }
                    },
                    child: Text("Update")),
              )
          ],
        ),
      ),
    );
  }
}

class ShowInf extends StatelessWidget {
  String title;
  String value;
  bool? editStatus;
  TextEditingController? controller;
  ShowInf({
    this.controller,
    this.editStatus,
    required this.value,
    required this.title,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextFormField(
            controller: controller,
            enabled: editStatus ?? false,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(8),
              hintText: value,
              focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  // borderSide: BorderSide.none
                  borderSide: BorderSide(
                      color: Colors.black, style: BorderStyle.solid)),
              border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.black)),
            ),
          )
        ],
      ),
    );
  }
}
