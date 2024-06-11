import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/auth/views/register_page.dart';
import 'package:mobilefinalhcmus/feature/intro/views/intro.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/profie/views/profile_inf/profile_inf.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
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
        backgroundColor: Colors.white,
        appBar: HeaderOfProfile(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ShowProfile(),
              FeatureOfProfile(
                type: ButtonType.VALIDATE_TOKEN,
                context: context,
                titleOfFeature: "Profile",
                callback:(token) {
                  print(token);
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (token == null) {
                        return LoginPage();
                      } else {
                        return ProfileInfor();
                      }
                    },
                  ));
                },
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                context: context,
                type: ButtonType.VALIDATE_TOKEN,
                titleOfFeature: "My orders",
                callback: (token) {
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
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                context: context,
                callback: (token) {},
                titleOfFeature: "My bookings",
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                type: ButtonType.VALIDATE_TOKEN,
                context: context,
                callback: (token) {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      if (token == null) {
                        return LoginPage();
                      } else {
                        return ShippingAdderssPage();
                      }
                    },
                  ));
                },
                titleOfFeature: "Shipping address",
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              FeatureOfProfile(
                context: context,
                callback: (token) {},
                titleOfFeature: "Settings",
              ),
              Divider(
                color: Colors.grey,
                thickness: 0.2,
              ),
              if (token != null) SignOutProfile()
            ],
          ),
        ));
  }
}

class HeaderOfProfile extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      title: Text(
        "My profile",
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56);
}

class ShowProfile extends StatelessWidget {
  ShowProfile({
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
          Expanded(
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
                          child: Text(
                            profile?['username'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        Container(
                          child: Text(profile?['email']),
                          alignment: Alignment.centerLeft,
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
                                return RegisterPage();
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
                      SizedBox(
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
