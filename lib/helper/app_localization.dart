import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobilefinalhcmus/helper/app_localization_delegate.dart';

class AppLocalizations{
  final Locale locale;
  AppLocalizations(this.locale);

  Map<String,dynamic> _localizedStrings = {};

  static const LocalizationsDelegate<AppLocalizations> delegate = AppLocalizationDelegate();
  static AppLocalizations? of (BuildContext context){
    return Localizations.of(context, AppLocalizations);
  }
  Future<bool> load(  )async{
    String jsonString = await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String,dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value));

    return true;

  }

  dynamic translate (String key){
    return _localizedStrings[key];
  }
} 