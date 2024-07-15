import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool editStatus = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final profile = context.watch<AuthenticateProvider>().profile;
    usernameController.text = profile?['name'];
    addressController.text = profile?['address'];
    emailController.text = profile?['email'];
    phoneController.text = profile?['phone'];
    ageController.text = (profile?['age']).toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Edit profile",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            ShowInf(
              controller: usernameController,
              editStatus: editStatus,
              title: "Name",
              value: profile?['name'],
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
              controller: phoneController,
              editStatus: editStatus,
              title: "Phone",
              value: profile?['phone'],
            ),
            if (editStatus)
              Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(150, 15)),
                    onPressed: () async {
                      final renderBox = context.findRenderObject() as RenderBox;
                      final size = renderBox.size;
                      print(size.height);
                      print(size.width);
                      final controller = showOverlay(
                          context: context,
                          child: Container(
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(color: Colors.transparent),
                            child: Container(
                              height: size.height * 0.2,
                              width: size.width * 0.5,
                              child: Material(
                                  borderRadius: BorderRadius.circular(15),
                                  elevation: 1,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary
                                      .withAlpha(150),
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: CircularProgressIndicator(
                                            color: Theme.of(context).textTheme.bodyMedium?.color,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          child: Text(
                                            "Loading...",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ));
                      controller['show']();
                      await context.read<AuthenticateProvider>().updateProfile(
                          token: context.read<AuthenticateProvider>().token!,
                          address: addressController.text,
                          
                          age: int.parse(ageController.text),
                          name: usernameController.text,
                          gender: " ",
                          phone: phoneController.text);
                      controller['hide']();
                      final error = context
                          .read<AuthenticateProvider>()
                          .httpResponseFlutter
                          .errorMessage;
                      if (error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red, content: Text(error)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text("success")));
                        editStatus = false;
                      }
                    },
                    child: const Text("Update")),
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
      padding: const EdgeInsets.all(8),
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
              contentPadding: const EdgeInsets.all(8),
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
