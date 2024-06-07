import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
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
import 'package:mobilefinalhcmus/provider/setting_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
final appLinks = AppLinks();
void main() async{
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
        ChangeNotifierProvider(create: (context) => SettingsProvider(),),
        ChangeNotifierProvider(create: (context) => ShopProvider(),),
        ChangeNotifierProvider(create: (context) => AuthenticateProvider(),),
        ChangeNotifierProvider(create: (context) => ProfileProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider(),),
        ChangeNotifierProvider(create: (context) => BookingProvider(),),
        ChangeNotifierProvider(create: (context) => CheckoutProvider(),),
        ChangeNotifierProvider(create: (context) => HomeProvider(),)
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: customTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => IntroPage(),
          '/tenant': (context) => TenantPage(),
          '/auth/login':(context) => LoginPage(),
          '/auth/signup':(context) => RegisterPage(),
          '/home':(context) => MainPage(),
          '/forgetpassword':(context) => ForgetPasswordPage(),
          '/shop/search_page': (context) => SearchPage(),
          '/forgetpassword/verify':(context) => VerifyPasswordPage(),
          '/forgetpassword/createpassword':(context) => CreatePasswordPage(),
          '/profile/orders':(context) => OrderPage(),
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        
        title: Text(widget.title),
      ),
      body: Center(
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
