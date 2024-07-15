import 'dart:async';

import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilefinalhcmus/components/failed_page.dart';
import 'package:mobilefinalhcmus/components/show_overlay.dart';
import 'package:mobilefinalhcmus/components/success_page.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/book/views/booking_page.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/home_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/booking/profile_booking_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/profie_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/shipping_address/shipping_address_page.dart';
import 'package:mobilefinalhcmus/feature/shop/views/product_page.dart';
import 'package:mobilefinalhcmus/main.dart';
import 'package:mobilefinalhcmus/provider/theme_provider.dart';
import 'package:mobilefinalhcmus/widgets/loading_widget.dart';
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
  Map<String, dynamic>? loadingController;
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
      MyApp.platform.setMethodCallHandler((call) async {
        switch (call.method) {
          case 'navigateTo':
            print(call.arguments);
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return ProfileBooking();
              },
            ));
            break;
          default:
            throw MissingPluginException();
        }
      });

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        appLinks.uriLinkStream.listen((uri) {
          // Do something (navigation, ...)
          Map<String, dynamic> params = uri.queryParameters;
          print(params['status'].toString().toLowerCase());
          if (params['status'].toString().toLowerCase() == "success") {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const SuccessPage();
              },
            ));
          } else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return const FailedPage();
              },
            ));
          }
        });

        print(authenticateProvider.httpResponseFlutter.errorMessage);
        // after intro, check error when refresh token
        if (authenticateProvider.httpResponseFlutter.errorMessage != null) {
          await prefs.remove("token");
          await prefs.remove("refreshToken");
          await prefs.remove("username");
          await QuickAlert.show(
              context: context,
              text: "Your login session has expired",
              textColor: (Theme.of(context).textTheme.bodyMedium?.color)!,
              confirmBtnText: "Yes",
              cancelBtnText: "No",
              showCancelBtn: true,
              onConfirmBtnTap: () async {
                setState(() {
                  homeProvider.setIndex = 0;
                });
                Navigator.pop(context);
              },
              type: QuickAlertType.info);
        } else {
          expiredTokenTime = getRefreshToken();
        }
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
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print(loadingController);
      if (loadingController == null && authenticateProvider.token != null) {
        loadingController = LoadingWidget(context);
        loadingController?['show']();
        await context
            .read<AuthenticateProvider>()
            .refreshTokenFunc(refreshToken: authenticateProvider.refreshToken!);
        loadingController?['hide']();
        loadingController = null;
      }
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
        height: 56,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,

        animationCurve: Curves.linear,
        selectedIndex: context.read<HomeProvider>().seletedIndex!,
        iconSize: 30,
        showElevation: false,
        // use this to remove appBar's elevation
        onItemSelected: (index) => setState(() {
          homeProvider.setIndex = index;
          context.read<HomeProvider>().setTemp = 0;
        }),

        items: [
          FlashyTabBarItem(
            activeColor: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedLabelStyle!
                .color!,
            icon: const Icon(Icons.home_outlined),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            activeColor: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedLabelStyle!
                .color!,
            icon: const Icon(Icons.shopping_cart_outlined),
            title: const Text('Shop'),
          ),
          FlashyTabBarItem(
            activeColor: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedLabelStyle!
                .color!,
            icon: const Icon(Icons.shopping_bag_outlined),
            title: const Text('Book'),
          ),
          // FlashyTabBarItem(
          //   icon: Icon(Icons.book_outlined),
          //   title: Text('Service'),
          // ),
          FlashyTabBarItem(
            activeColor: Theme.of(context)
                .bottomNavigationBarTheme
                .unselectedLabelStyle!
                .color!,
            icon: const Icon(Icons.person_4_outlined),
            title: const Text('Profile'),
          ),
        ],
      ),
    );
  }
}
