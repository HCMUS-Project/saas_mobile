import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/auth/views/register_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/booking/profile_booking_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/profile_inf/profile_inf.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/profie/views/settings/setting_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/shipping_address/shipping_address_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/widgets/feature_profile.dart';
import 'package:mobilefinalhcmus/feature/profie/views/widgets/sign_out_profile.dart';
import 'package:provider/provider.dart';

class ProfiePage extends StatelessWidget {
  const ProfiePage({super.key});

  @override
  Widget build(BuildContext context) {
    final token = context.read<AuthenticateProvider>().token;
    
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const HeaderOfProfile(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const ShowProfile(),
              FeatureOfProfile(
                type: ButtonType.VALIDATE_TOKEN,
                context: context,
                titleOfFeature: "Profile",
                callback:({token}) {
                  print(token);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (token == null) {
                        return LoginPage();
                      } else {
                        return const ProfileInfor();
                      }
                    },
                  ));
                },
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                context: context,
                type: ButtonType.VALIDATE_TOKEN,
                titleOfFeature: "My orders",
                callback: ({token}) {
                  if (token == null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return LoginPage();
                      },
                    ));
                  } else {
                    context.read<ProfileProvider>().GetOrder(
                      state: OrderState.pending.name
                    );
                    Navigator.of(context).pushNamed("/profile/orders");
                  }
                },
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                type: ButtonType.VALIDATE_TOKEN,
                context: context,
                callback: ({token}) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (token == null) {
                        return LoginPage();
                      } else {
                        return const ProfileBooking();
                      }
                    },
                  ));
                },
                titleOfFeature: "My bookings",
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                type: ButtonType.VALIDATE_TOKEN,
                context: context,
                callback: ({token}) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (token == null) {
                        return LoginPage();
                      } else {
                        return const ShippingAdderssPage();
                      }
                    },
                  ));
                },
                titleOfFeature: "Shipping address",
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                context: context,
                type: ButtonType.NORMAL,
                callback: ({token}) {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                    return SettingPage();
                  },));
                },
                titleOfFeature: "Settings",
              ),
              const Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              if (token != null) const SignOutProfile()
            ],
          ),
        ));
  }
}

class HeaderOfProfile extends StatelessWidget implements PreferredSizeWidget {
  const HeaderOfProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      
      title: Text(
        "My profile",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(56);
}

class ShowProfile extends StatelessWidget {
  const ShowProfile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    Map<String, dynamic>? profile;

    final token = context.read<AuthenticateProvider>().token;
    if (token != null) {
      profile = context.read<AuthenticateProvider>().profile;
    }
    
    return Container(
      child: Row(
        children: [
          const Expanded(
              flex: 2,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/avatar.png"),
              )),
          token != null
              ? Expanded(
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            profile?['username'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(profile?['email']),
                        )
                      ],
                    ),
                  ))
              : Expanded(
                  flex: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return const RegisterPage();
                              },
                            ));
                          },
                          child: Text(
                            "Register",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return LoginPage();
                              },
                            ));
                          },
                          child: Text(
                            "Login",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold),
                          ))
                    ],
                  ))
        ],
      ),
    );
  }
}
