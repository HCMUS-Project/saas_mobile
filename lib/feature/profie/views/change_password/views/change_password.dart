import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/widgets/password_textfield.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController currentPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text((AppLocalizations.of(context)!
            .translate('userSettings')!)['changePassword']),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "${AppLocalizations.of(context)!.translate('enter')!} ${AppLocalizations.of(context)!.translate('currentPassword')!}"),
              PasswordFielddWidget(
                hintText: "Current password",
                controller: currentPassController,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                  "${(AppLocalizations.of(context)!.translate('enter')!)} ${AppLocalizations.of(context)!.translate('newPassword')!}"),
              PasswordFielddWidget(
                hintText: "New password",
                controller: newPassController,
              ),
              SizedBox(
                height: 10,
              ),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.red),
                ),
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (currentPassController.text != "" &&
                            newPassController.text != "") {
                          final response = await context
                              .read<AuthenticateProvider>()
                              .changePassword(
                                  token: context
                                      .read<AuthenticateProvider>()
                                      .token!,
                                  password: currentPassController.text,
                                  newPassword: newPassController.text
                            );
                          print(response.result);
                          if (response.errorMessage != null) {
                            setState(() {
                              errorMessage = response.errorMessage;
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Change successfully",
                                toastLength: Toast.LENGTH_SHORT,
                                backgroundColor: Colors.green,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                fontSize: 16.0
                            );
                          }
                        } else {
                          if (currentPassController.text == "") {
                            setState(() {
                              errorMessage = "please enter current password";
                            });
                          } else if (newPassController.text == "") {
                            setState(() {
                              errorMessage = "please enter new password";
                            });
                          }
                        }
                      },
                      child: Text("Send")))
            ],
          ),
        ),
      ),
    );
  }
}
