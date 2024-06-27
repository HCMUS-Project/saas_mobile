import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/profile_inf/profile_edit_inf.dart';
import 'package:provider/provider.dart';

class ProfileInfor extends StatefulWidget {
  const ProfileInfor({super.key});

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
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
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
                      padding: const EdgeInsets.all(0),
                      alignment: Alignment.center,
                      child: const CircleAvatar(
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
                                fixedSize: const Size(100, 15)),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                return EditProfile();
                              },));
                            },
                            child: const Text("Edit"))
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
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!)),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Icon(Icons.person)),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Name",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            profile?['username'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!)),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Icon(Icons.email)),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Email",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            profile?['email'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!)),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Icon(Icons.home)),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Address",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            profile?['address'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!)),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Icon(Icons.face)),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Age",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            (profile?['age']).toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!)),
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Icon(Icons.domain)),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Domain",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                          Text(
                                            profile?['domain'],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            // ShowInf(
                            //   controller: emailController,
                            //   editStatus: editStatus,
                            //   title: "Email",
                            //   value: profile?['email'],
                            // ),
                            // ShowInf(
                            //   controller: addressController,
                            //   editStatus: editStatus,
                            //   title: "Address",
                            //   value: profile?['address'],
                            // ),
                            // ShowInf(
                            //   controller: ageController,
                            //   editStatus: editStatus,
                            //   title: "Age",
                            //   value: (profile?['age']).toString(),
                            // ),
                            // ShowInf(
                            //   title: "Domain",
                            //   value: profile?['domain'],
                            // ),
                          ],
                        ),
                      )),
                )),
            
          ],
        ),
      ),
    );
  }
}


