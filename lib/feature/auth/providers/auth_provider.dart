import 'dart:convert';

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:http/http.dart' as http;
import 'package:mobilefinalhcmus/main.dart';

class AuthenticateProvider extends ChangeNotifier {
  String? _homeRoute;
  String? get homeRoute => _homeRoute;
  set setHomeRoute(String homeRoute) {
    _homeRoute = homeRoute;
  }

  String? get token => prefs.getString("token");
  String? get refreshToken => prefs.getString("refreshToken");
  String? _domain;
  String? get domain => dotenv.env['DOMAIN'];
  set setDomain(String domain) {
    _domain = domain;
  }

  Map<String, dynamic>? get profile => json.decode(prefs.getString("profile")!);
  String? get username => prefs.getString("username");
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();

  Future<void> sendOtp({required String domain, required String email}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> data = {};
      data['domain'] = domain;
      data['email'] = email;

      final rs = await http.post(
          Uri.parse("${dotenv.env['HTTP_URI']}auth/send-mail-otp"),
          body: json.encode(data),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          });
      final bodyRes = json.decode(rs.body);
      print(bodyRes);
      if (bodyRes['statusCode'] >= 400) {
        throw FlutterException(bodyRes['message'], bodyRes['statusCode']);
      }

      httpResponseFlutter.update(
        result: bodyRes['data'],
      );
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          statusCode: e.toJson()['statusCode'],
          errorMessage: e.toJson()['message']);
    }
  }

  Future<void> verifyOtp(
      {required String domain,
      required String email,
      required String otp}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> data = {};
      data['domain'] = domain;
      data['email'] = email;
      data['otp'] = otp;

      final rs = await http.post(
        Uri.parse("${dotenv.env['HTTP_URI']}auth/verify-account"),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(data),
      );

      final resBody = json.decode(rs.body);
      if (resBody['statusCode'] >= 400) {
        throw FlutterException(resBody['message'], resBody['statusCode']);
      }

      httpResponseFlutter.update(
          result: resBody['data'], statusCode: resBody['statusCode']);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          statusCode: e.toJson()['statusCode'],
          errorMessage: e.toJson()['message']);
    }
  }

  Future<void> registerWithPassword(
      {required String phone,
      required String email,
      required String domain,
      required String password,
      required String username}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(isLoading: true);
      notifyListeners();
      Map<String, dynamic> data = {};
      data['device'] = "mobile";
      data['username'] = username;
      data['phone'] = phone;
      data['domain'] = domain;
      data['email'] = email;
      data['password'] = password;
      print("${dotenv.env['HTTP_URI']}auth/sign-up");
      final rs = await http.post(
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data),
          Uri.parse("${dotenv.env['HTTP_URI']}auth/sign-up"));
      final resBody = json.decode(rs.body);
      print(resBody);

      if (resBody['statusCode'] >= 400) {
        throw FlutterException(resBody['message'], resBody['statusCode']);
      }
      httpResponseFlutter.update(
        result: resBody['data'],
      );
      notifyListeners();
    } on FlutterException catch (e) {
      httpResponseFlutter.update(isLoading: false);
      notifyListeners();
      httpResponseFlutter.update(
          statusCode: e.toJson()['statusCode'],
          errorMessage: e.toJson()['message']);
    }
  }

  Future<void> SignIn(
      {required String domain,
      required String email,
      required String password}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      notifyListeners();
      Map<String, dynamic> data = {};
      data['domain'] = domain;
      data['email'] = email;
      data['password'] = password;
      final rs =
          await http.post(Uri.parse("${dotenv.env['HTTP_URI']}auth/sign-in"),
              headers: {
                'Content-type': 'application/json',
                'Accept': 'application/json',
              },
              body: json.encode(data));
      print(rs.body);
      final bodyRes = json.decode(rs.body);

      if (bodyRes['statusCode'] >= 400) {
        throw FlutterException(bodyRes['message'], bodyRes['statusCode']);
      }

      httpResponseFlutter.update(result: bodyRes['data']);

      Map<String, dynamic> decodedToken =
          JwtDecoder.decode(httpResponseFlutter.result?['accessToken']);
      
      await prefs.setString("domain", domain);
      
      await prefs.setString(
          "token", httpResponseFlutter.result?['accessToken']);
      await prefs.setString(
          "refreshToken", httpResponseFlutter.result?['refreshToken']);

      await getUserInfo(token: token!);

      await prefs.setString(
          "username", httpResponseFlutter.result?['username']);
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
        errorMessage: e.toJson()['message'],
        statusCode: e.toJson()['statusCode'],
      );
    }
  }

  Future<void> SignOut({required String token}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      final rs = await http.get(
        Uri.parse("${dotenv.env['HTTP_URI']}auth/sign-out"),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );

      final bodyRes = json.decode(rs.body);
      if (bodyRes['statusCode'] >= 400) {
        throw FlutterException(bodyRes['message'], bodyRes['statusCode']);
      }

      await prefs.remove("token");
      await prefs.remove("refreshToken");
      await prefs.remove("username");
      await prefs.remove("profile");
      httpResponseFlutter.update(result: bodyRes['data']);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
        errorMessage: e.toJson()['message'],
        statusCode: e.toJson()['statusCode'],
      );
    }
  }

  Future<void> updateProfile(
      {required String token,
      String? username,
      String? phone,
      String? address,
      String? name,
      String? gender,
      int? age}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> data = {};

      data['username'] = username;
      data['phone'] = phone;
      data['address'] = address;
      data['name'] = name;
      data['gender'] = "male";
      data['age'] = age;

      final rs = await http.post(
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.acceptHeader: 'application/json',
            HttpHeaders.authorizationHeader: "Bearer $token"
          },
          Uri.parse('${dotenv.env['HTTP_URI']}auth/update-profile'),
          body: json.encode(data));

      final bodyRes = json.decode(rs.body);
      if (bodyRes['statusCode'] >= 400) {
        throw FlutterException(bodyRes['message'], bodyRes['statusCode']);
      }

      httpResponseFlutter.update(
          result: bodyRes['data'], statusCode: bodyRes['statusCode']);
      await getUserInfo(token: token);
      notifyListeners();
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
        errorMessage: e.toJson()['message'],
        statusCode: e.toJson()['statusCode'],
      );
    }
  }

  Future<void> getUserInfo({required String token}) async {
    try {
      final rs = await http.get(
          headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
          Uri.parse("${dotenv.env['HTTP_URI']}auth/get-profile"));

      final bodyRes = json.decode(rs.body);

      if (bodyRes['statusCode'] >= 400) {
        throw FlutterException(bodyRes['message'], bodyRes['statusCode']);
      }

      httpResponseFlutter.update(result: bodyRes['data']);
      // _profile = bodyRes['data'];
      await prefs.setString("profile", json.encode(bodyRes['data']));
    } on FlutterException catch (e) {
      print(e.toJson()['message']);
      httpResponseFlutter.update(
        errorMessage: e.toJson()['message'],
        statusCode: e.toJson()['statusCode'],
      );
    }
  }

  Future<void> refreshTokenFunc({required String refreshToken}) async {
    try {
      print("hello refresh");
      print(refreshToken);
      httpResponseFlutter = HttpResponseFlutter.unknown();
      final rs = await http.post(
          headers: {HttpHeaders.authorizationHeader: "Bearer $refreshToken"},
          Uri.parse("${dotenv.env['HTTP_URI']}auth/refresh-token"));
      

      final bodyRes = json.decode(rs.body);

      if (rs.statusCode >= 400) {
        throw FlutterException(bodyRes['message'], rs.statusCode);
      }

      httpResponseFlutter.update(
          result: bodyRes['data'], statusCode: bodyRes['statusCode']);

      await prefs.remove("token");
      await prefs.remove("refreshToken");
      await prefs.setString(
          "token", httpResponseFlutter.result?['accessToken']);
      await prefs.setString(
          "refreshToken", httpResponseFlutter.result?['refreshToken']);
    } on FlutterException catch (e) {
      print("Error Server $e");
      print(e.toJson()['message']);
      httpResponseFlutter.update(
          statusCode: e.toJson()['statusCode'],
          errorMessage: e.toJson()['message']);
    }
  }
}
