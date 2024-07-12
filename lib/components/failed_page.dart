import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class FailedPage extends StatelessWidget {
  const FailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  shape: BoxShape.circle,
                ),
                height: 128,
                width: 128,
                child: Image.asset("assets/gif/failed.gif"),
              ),
            ),
            Text(
              "Thank you!",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  ),
            ),
            Text(
              "Order Failed",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            Container(
              child: ElevatedButton(
                  onPressed: () {
                    final homeRoute =
                        context.read<AuthenticateProvider>().homeRoute;
                    Navigator.of(context)
                        .popUntil(ModalRoute.withName(homeRoute!));
                  },
                  child: Text("Back to home")),
            )
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //           shape: const BeveledRectangleBorder(),
            //           backgroundColor: Colors.green),
            //       onPressed: () {
            //         final homeRoute = context.read<AuthenticateProvider>().homeRoute;
            //         Navigator.of(context).popUntil(ModalRoute.withName(homeRoute!));
            //       },
            //       child: Text(
            //         "Back to home",
            //         // style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            //         //       color: Colors.white,
            //         //     ),
            //       )),
            // )
          ],
        ),
      ),
    );
  }
}
