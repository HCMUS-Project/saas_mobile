import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/custom_theme.dart';
import 'package:mobilefinalhcmus/feature/auth/providers/auth_provider.dart';
import 'package:mobilefinalhcmus/feature/auth/views/login_page.dart';
import 'package:mobilefinalhcmus/feature/auth/views/register_page.dart';
import 'package:mobilefinalhcmus/feature/book/provider/booking_provider.dart';
import 'package:mobilefinalhcmus/feature/cart/provider/cart_provider.dart';
import 'package:mobilefinalhcmus/feature/checkout/providers/checkout_provider.dart';
import 'package:mobilefinalhcmus/feature/forgetpassword/views/new_password.dart';
import 'package:mobilefinalhcmus/feature/forgetpassword/views/verifi_password.dart';
import 'package:mobilefinalhcmus/feature/home/provider/home_provider.dart';
import 'package:mobilefinalhcmus/feature/home/views/main_page.dart';
import 'package:mobilefinalhcmus/feature/intro/views/intro.dart';
import 'package:mobilefinalhcmus/feature/forgetpassword/views/forget_password.dart';
import 'package:mobilefinalhcmus/feature/profie/views/orders/order_page.dart';
import 'package:mobilefinalhcmus/feature/profie/views/provider/profile_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/provider/shop_provider.dart';
import 'package:mobilefinalhcmus/feature/shop/views/search/search_page.dart';
import 'package:mobilefinalhcmus/feature/tenant/views/tenant_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';
import 'package:mobilefinalhcmus/provider/app_language_provider.dart';
import 'package:mobilefinalhcmus/provider/setting_provider.dart';
import 'package:mobilefinalhcmus/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
final appLinks = AppLinks();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await dotenv.load(fileName: ".env");
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShopProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthenticateProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BookingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CheckoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppLanguageProvider(),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return FutureBuilder(
            future: Future.wait([
              context.read<AppLanguageProvider>().fetchLocale(),
              value.getTheme(
                  domain: context.read<AuthenticateProvider>().domain!),
              value.getTenantProfile(
                  domain: context.read<AuthenticateProvider>().domain!)
            ]),
            builder: (context, snapshot) {
              final rs = value.httpResponseFlutter.result?['themeConfig'];
              ThemeConfig? theme;

              if (rs != null) {
                theme = ThemeConfig.fromJson(rs);
                value.setRoute = "/home";
              }

              return Consumer<AppLanguageProvider>(
                builder: (context, model, child) {
                  print(model.appLocale.languageCode);
                  return MaterialApp(
                    title: 'Flutter Demo',
                    debugShowCheckedModeBanner: false,
                    theme: rs != null ? theme?.theme : customTheme,
                    initialRoute: '/',
                    routes: {
                      '/': (context) => IntroPage(),
                      '/auth/login': (context) => LoginPage(),
                      '/auth/signup': (context) => const RegisterPage(),
                      '/home': (context) => const MainPage(),
                      '/forgetpassword': (context) => ForgetPasswordPage(),
                      '/shop/search_page': (context) => SearchPage(),
                      '/forgetpassword/verify': (context) =>
                          VerifyPasswordPage(),
                      '/forgetpassword/createpassword': (context) =>
                          CreatePasswordPage(),
                      '/profile/orders': (context) => const OrderPage(),
                    },
                    locale: model.appLocale,
                    supportedLocales: const [
                      Locale('en', 'US'),
                      Locale('vi', 'VN')
                    ],
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
