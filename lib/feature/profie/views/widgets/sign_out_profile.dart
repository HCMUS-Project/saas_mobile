import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/intro/views/intro.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:provider/provider.dart';

class SignOutProfile extends StatelessWidget {
  const SignOutProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () async {
          await context
              .read<AuthenticateProvider>()
              .SignOut(token: context.read<AuthenticateProvider>().token!);
          final error = context
              .read<AuthenticateProvider>()
              .httpResponseFlutter
              .errorMessage;
          if (error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(backgroundColor: Colors.red, content: Text(error)));
          } else {
            final data =
                context.read<AuthenticateProvider>().httpResponseFlutter.result;
            if (data != null) {
              context.read<HomeProvider>().setIndex = 0;
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  backgroundColor: Colors.red, content: Text("Error")));
            }
          }
        },
        title: Text(
          (AppLocalizations.of(context)!.translate('logout')!),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: const Icon(Icons.logout),
      ),
    );
  }
}
