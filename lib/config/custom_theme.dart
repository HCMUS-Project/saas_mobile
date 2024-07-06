import 'package:flutter/material.dart';

ThemeData customTheme = ThemeData(
    appBarTheme: const AppBarTheme(
        scrolledUnderElevation: 0,
        color: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF161D3A))),
    colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.black,
        primary: Colors.white,
        secondary: const Color(0xFF161D3A)),
    scaffoldBackgroundColor: Colors.white,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Color(0xFF161D3A)),
    iconTheme: const IconThemeData(color: Color(0xFF161D3A), size: 24),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF161D3A),
    )),
    textTheme: const TextTheme(
        titleLarge: TextStyle(color: Colors.black),
        titleMedium: TextStyle(color: Colors.black),
        titleSmall: TextStyle(color: Colors.black),
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        bodySmall: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
        labelMedium: TextStyle(color: Colors.black),
        labelSmall: TextStyle(color: Colors.black)));

class ThemeConfig {
  late ThemeData _theme;
  Color? headerColor;
  Color? headerTextColor;
  Color? bodyColor;
  Color? bodyTextColor;
  Color? footerColor;
  Color? footerTextColor;
  String? textFont;
  Color? buttonColor;
  Color? buttonTextColor;
  int? buttonRadius;

  ThemeConfig(
      {this.bodyColor,
      this.bodyTextColor,
      this.buttonColor,
      this.buttonRadius,
      this.buttonTextColor,
      this.footerColor,
      this.footerTextColor,
      this.headerColor,
      this.headerTextColor,
      this.textFont});

  factory ThemeConfig.fromJson(Map<String, dynamic> json) {
    int headerColorInt = int.parse(
        json['headerColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int headerTextColorInt = int.parse(
        json['headerTextColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int bodyColorInt = int.parse(
        json['bodyColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int bodyTextColorInt = int.parse(
        json['bodyTextColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int footerColorInt = int.parse(
        json['footerColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int footerTextColorInt = int.parse(
        json['footerTextColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int buttonColorInt = int.parse(
        json['buttonColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);
    int buttonTextColorInt = int.parse(
        json['buttonTextColor'].toString().replaceFirst('#', 'FF'),
        radix: 16);

    return ThemeConfig(
      headerColor: Color(headerColorInt),
      headerTextColor: Color(headerTextColorInt),
      bodyColor: Color(bodyColorInt),
      bodyTextColor: Color(bodyTextColorInt),
      footerColor: Color(footerColorInt),
      footerTextColor: Color(footerTextColorInt),
      textFont: json['textFont'].toString(),
      buttonColor: Color(buttonColorInt),
      buttonTextColor: Color(buttonTextColorInt),
      buttonRadius: json['buttonRadius'],
    );
  }

  ThemeData get theme => ThemeData(
      datePickerTheme: DatePickerThemeData(
        backgroundColor: headerColor,
        cancelButtonStyle: ElevatedButton.styleFrom(
        ),
        confirmButtonStyle: ElevatedButton.styleFrom(
        ),
        elevation: 0,

      ),
      
      appBarTheme: AppBarTheme(
          scrolledUnderElevation: 0,
          color: headerColor,
          titleTextStyle: TextStyle(
            color: headerTextColor
          ),
          iconTheme: IconThemeData(color: headerTextColor)),
      colorScheme: ColorScheme.fromSeed(
          onPrimary: bodyTextColor,
          onSurface: bodyTextColor,
          
          seedColor: Colors.black, primary: bodyColor, secondary: headerColor),
      scaffoldBackgroundColor: bodyColor,
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Color.fromARGB(255, 34, 38, 54)),
      iconTheme: IconThemeData(color: bodyTextColor, size: 24),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        textStyle: TextStyle(color: buttonTextColor),
        backgroundColor: buttonColor,
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: footerColor,
          
        unselectedLabelStyle: TextStyle(  
          color: footerTextColor
        )
      ),
      textTheme: TextTheme(
          titleLarge: TextStyle(color: bodyTextColor),
          titleMedium: TextStyle(color: bodyTextColor),
          titleSmall: TextStyle(color: bodyTextColor),
          bodyLarge: TextStyle(color: bodyTextColor),
          bodyMedium: TextStyle(color: bodyTextColor),
          bodySmall: TextStyle(color: bodyTextColor),
          labelLarge: TextStyle(color: bodyTextColor),
          labelMedium: TextStyle(color: bodyTextColor),
          labelSmall: TextStyle(color: bodyTextColor)));
}
