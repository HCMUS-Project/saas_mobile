import 'dart:async';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/components/success_page.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/booking_page.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/home_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/profie_page.dart';
import 'package:mobilefinalhcmus/feature/shop/views/product_page.dart';
import 'package:mobilefinalhcmus/main.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  Timer? expiredTokenTime;
  late HomeProvider homeProvider;
  late AuthenticateProvider authenticateProvider;
  List<Widget> tabItems = [
    const HomePage(),
    const ProductPage(),
    BookingPage(),
    // ServicePage(),
    const ProfiePage()
  ];

  Timer getRefreshToken() {
    return Timer.periodic(const Duration(hours: 1), (timer) async {
      print("expired token");
      await authenticateProvider.refreshTokenFunc(
          refreshToken: authenticateProvider.refreshToken!);
    });
  }

  @override
  void initState() {
    authenticateProvider = context.read<AuthenticateProvider>();
    homeProvider = context.read<HomeProvider>();
    final token = authenticateProvider.token;
    if (token != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        appLinks.uriLinkStream.listen((uri) {
          // Do something (navigation, ...)
          Map<String, dynamic> params = uri.queryParameters;
          if (params['message'].toString().toLowerCase() == "success") {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const SuccessPage();
              },
            ));
          }
        });

        await checkToken(context);
        // await FutureBuilder(
        //     future: checkToken(context),
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Container(
        //           decoration: BoxDecoration(
        //               color: Theme.of(context).colorScheme.primary),
        //           child: Center(),
        //         );
        //       }

        //       if (snapshot.connectionState == ConnectionState.done) {
        //         print('done');
        //         // WidgetsBinding.instance.addPostFrameCallback((_) {
        //         // });
        //       }
        //       return Container();
        //     });
      });
    }

    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    expiredTokenTime?.cancel();

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Future.wait([
        context
            .read<AuthenticateProvider>()
            .refreshTokenFunc(refreshToken: authenticateProvider.refreshToken!)
      ]);
    }
  }

  Future<void> checkToken(BuildContext context) async {
    print("check token");
    await context.read<AuthenticateProvider>().refreshTokenFunc(
        refreshToken: context.read<AuthenticateProvider>().refreshToken!);

    if (context.read<AuthenticateProvider>().httpResponseFlutter.errorMessage !=
        null) {
      await prefs.remove("token");
      await prefs.remove("refreshToken");
      await prefs.remove("username");
      await QuickAlert.show(
          context: context,
          text: "Your login session has expired",
          textColor: Theme.of(context).colorScheme.secondary,
          confirmBtnText: "Yes",
          cancelBtnText: "No",
          showCancelBtn: true,
          onConfirmBtnTap: () async {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/',
              (route) => false,
            );
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (context) => IntroPage(),
            //     ),
            //     (route) => false);
          },
          type: QuickAlertType.info);
    } else {
      expiredTokenTime = getRefreshToken();
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthenticateProvider>().setHomeRoute =
        (ModalRoute.of(context)!.settings.name)!;

    return Scaffold(
      body: Center(
        child: tabItems[homeProvider.seletedIndex!],
      ),
      bottomNavigationBar: FlashyTabBar(
        animationCurve: Curves.linear,
        selectedIndex: context.read<HomeProvider>().seletedIndex!,
        iconSize: 30,
        showElevation: false, // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          homeProvider.setIndex = index;
          context.read<HomeProvider>().setTemp = 0;
        }),

        items: [
          FlashyTabBarItem(
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            title: const Text('Shop'),
          ),
          FlashyTabBarItem(
            icon: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Book'),
          ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.book_outlined),
          //   title: Text('Service'),
          // ),
          FlashyTabBarItem(
            icon: const Icon(Icons.person_4_outlined),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
