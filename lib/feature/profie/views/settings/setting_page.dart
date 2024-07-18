import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/main.dart';
import 'package:mobilefinalhcmus/provider/app_language_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (prefs.getBool("notiSwitch") == null) {
      prefs.setBool("notiSwitch", false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 8, right: 8),
        child: Container(
          height: 300,
          child: Material(
            borderRadius: BorderRadius.circular(15),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Icon(Icons.notifications_none_outlined)),
                          Expanded(
                              flex: 7,
                              child: Text(AppLocalizations.of(context)!
                                  .translate('notification')!)),
                          Expanded(
                              flex: 2,
                              child: Container(
                                child: Switch(
                                  activeColor: Theme.of(context)
                                      .elevatedButtonTheme
                                      .style
                                      ?.backgroundColor
                                      ?.resolve({}),
                                  value: prefs.getBool("notiSwitch")!,
                                  onChanged: (value) async {
                                    print(prefs.getBool("notiSwitch")!);
                                    final notiSwitch =
                                        prefs.getBool("notiSwitch");

                                    PermissionStatus notiPermissionStatus =
                                        await Permission.notification.status;
                                    print(notiPermissionStatus);
                                    if (!notiPermissionStatus.isGranted) {
                                      print("Notification");
                                      if (notiPermissionStatus ==
                                          PermissionStatus.permanentlyDenied) {
                                        Fluttertoast.showToast(
                                            msg:
                                                "Turn on notification in setting",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            fontSize: 16.0);
                                      }
                                      await Permission.notification.request();
                                    } else {
                                      final token = context
                                          .read<AuthenticateProvider>()
                                          .token;
                                      Map<String, dynamic>? profile;
                                      if (token != null) {
                                        profile = context
                                            .read<AuthenticateProvider>()
                                            .profile;

                                        try {
                                          if (!(notiSwitch!)) {
                                            await MyApp.platform.invokeMethod(
                                                "startSocketService",
                                                {'email': profile?['email']});
                                          } else {
                                            await MyApp.platform.invokeMethod(
                                                "stopSocketService");
                                          }

                                          await prefs.setBool("notiSwitch",
                                              !(prefs.getBool("notiSwitch")!));
                                          setState(() {});
                                        } catch (e) {
                                          print(e);
                                        }
                                      }else{
                                        Fluttertoast.showToast(
                                            msg: "You must login to turn on notification",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            fontSize: 16.0);
                                      }
                                    }
                                  },
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(flex: 1, child: Icon(Icons.language)),
                          Expanded(
                              flex: 7,
                              child: Text(
                                (AppLocalizations.of(context)!
                                    .translate('userSettings')!)['country'],
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                          Expanded(flex: 2, child: Container())
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        await displayMultiLanguage(context);
                      },
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex: 1, child: Icon(Icons.translate)),
                            Expanded(
                                flex: 7,
                                child: Text(
                                    (AppLocalizations.of(context)!.translate(
                                        'userSettings')!)['language'],
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: Colors.black)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Builder(builder: (context) {
                                        final language = context.select(
                                          (AppLanguageProvider value) {
                                            return value.appLocale;
                                          },
                                        );
                                        return Text(language.languageCode);
                                      }),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              flex: 1, child: Icon(Icons.lock_outline_sharp)),
                          Expanded(
                              flex: 7,
                              child: Text(
                                  (AppLocalizations.of(context)!.translate(
                                      'userSettings')!)['changePassword'],
                                  style:
                                      Theme.of(context).textTheme.bodyMedium)),
                          Expanded(
                              flex: 2,
                              child: Icon(Icons.arrow_forward_ios_rounded))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> displayMultiLanguage(BuildContext context) async {
    final appLanguage = context.read<AppLanguageProvider>();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentTextStyle: Theme.of(context).textTheme.bodyMedium,
          scrollable: true,
          title: Text("Choose language"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/images/vietnam.png"),
                    ),
                    Expanded(
                        child: Container(
                      child: TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              alignment: Alignment.centerLeft),
                          onPressed: () {
                            appLanguage.changeLanguage(const Locale('vi'));
                            print("tieng viet");
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Tiếng Việt",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    )),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage:
                          AssetImage("assets/images/united-kingdom.png"),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                          style: TextButton.styleFrom(
                              alignment: Alignment.centerLeft),
                          onPressed: () {
                            appLanguage.changeLanguage(const Locale('en'));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "English",
                            style: Theme.of(context).textTheme.bodyMedium,
                          )),
                    )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
