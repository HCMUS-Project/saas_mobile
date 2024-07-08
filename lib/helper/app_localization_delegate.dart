import 'package:flutter/material.dart';
import 'package:mobilefinalhcmus/helper/app_localization.dart';

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations>{
  const AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    // TODO: implement isSupported
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale)async {
    // TODO: implement load
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    // TODO: implement shouldReload
    return false;
  }

}