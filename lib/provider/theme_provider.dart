import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mobilefinalhcmus/config/custom_theme.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/tenant/models/tenants_model.dart';

class ThemeProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  String initialRoute = '/';
  ThemeConfig? theme;
  TenantModel? tenant;
  set setRoute(String route){
    initialRoute = route;
  }

  Future<void> getTenantProfile(
    {
      required String domain
    }
  )async{
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {"domain": domain};

      final uri = Uri.parse("${dotenv.env['HTTP_URI']}tenant/profile/find")
          .replace(queryParameters: queryParameters);
    
      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri);

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      tenant = TenantModel.fromJson(result['data']);
   
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }
  Future<void> getTheme({required String domain}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {"domain": domain};

      final uri = Uri.parse("${dotenv.env['HTTP_URI']}tenant/configTheme/find")
          .replace(queryParameters: queryParameters);

      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri);

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      theme = ThemeConfig.fromJson(result['data']['themeConfig']) ;
      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }
}
