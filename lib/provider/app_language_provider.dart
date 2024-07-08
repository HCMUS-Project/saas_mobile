import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/main.dart';

class AppLanguageProvider extends ChangeNotifier {
  Locale _appLocale = const Locale('en');
  Locale get appLocale => _appLocale;

  Future<void> fetchLocale() async {
    if (prefs.getString('language_code') == null) {
      print(prefs.getString('language_code'));
      _appLocale = const Locale("en");

    }
    print("Language: ${prefs.getString('language_code')}");
    _appLocale = Locale(prefs.getString('language_code')!);
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }

    if (type == const Locale('vi')) {
      _appLocale = const Locale('vi');
      await prefs.setString("language_code", "vi");
      await prefs.setString("countryCode", "VN");
    } else {
      _appLocale = const Locale('en');
      await prefs.setString("language_code", 'en');
      await prefs.setString("countryCode", 'US');
    }
    notifyListeners();
  }
}
