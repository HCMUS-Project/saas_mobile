import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import "package:http/http.dart" as http;

class BookingProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  String? _selectedIndexEmployee;
  String? get selectedIndexEmployee => _selectedIndexEmployee;
  String? _seletedTimeForBooking;
  String? get selectedTimeForBooking => _seletedTimeForBooking;
  List<Map<String, dynamic>> bookingList = [];
  int page = 1;

  set setPage(int page) {
    this.page = page;
    notifyListeners();
  }

  set indexEmployee(String? index) {
    _selectedIndexEmployee = index;
    notifyListeners();
  }

  set timeForBooking(String time) {
    _seletedTimeForBooking = time;
    notifyListeners();
  }

  Future<HttpResponseFlutter> getAllService(
      {required String domain,
      int? priceLower,
      int? priceHigher,
      String? name}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "priceLower": priceLower,
        "priceHigher": priceHigher,
        "name": name,
        "domain": domain
      };

      queryParameters.removeWhere((key, value) => value == null);

      final uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}booking/services/search")
              ?.replace(
        queryParameters: queryParameters,
      );

      final rs = await http.get(
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
        uri!,
      );

      final body = json.decode(rs.body);

      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);

      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);

      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<HttpResponseFlutter> getAllEmployee(
      {required List<String> workDays,
      required List<String> workShift,
      required List<String> services,
      String? firstName,
      String? lastName,
      String? email}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "firstName": firstName ?? "Vo Le",
        "lastName": lastName ?? "Hoai",
        "email": email ?? "volehoai070902@gmail.com",
        "workDays": workDays,
        "workShift": workShift,
        "services": services
      };
      print(workDays);
      print(workShift);
      print(services);
      queryParameters.removeWhere((key, value) => value == null);
      final uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}booking/employee/search")
              ?.replace(
        queryParameters: queryParameters,
      );

      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!);
      print(rs.body);
      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<void> searchForBooking(
      {required String token,
      required String date,
      required String service,
      String? employee,
      String? startTime,
      String? endTime}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "employee": employee,
        "startTime": startTime,
        "endTime": endTime,
        "date": date,
        "service": service
      };
      queryParameters.removeWhere((key, value) => value == null);
      final uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}booking/bookings/search")
              ?.replace(queryParameters: queryParameters);

      final rs = await http.get(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!);

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
    }
  }

  void flushData() {
    _seletedTimeForBooking = null;
    _selectedIndexEmployee = null;
  }

  Future<void> createBooking(
      {required String token,
      required String date,
      required String service,
      required String note,
      String? employee,
      required String startTime}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      final uri = Uri.parse("${dotenv.env['HTTP_URI']}booking/bookings/create");
      Map<String, dynamic> data = {};
      data['date'] = date;
      data['note'] = note;
      data['service'] = service;
      data['startTime'] = startTime;
      data['employee'] = employee;
      print(date);
      print(service);
      print(startTime);
      final rs = await http.post(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri, body: json.encode(data));

      final body = json.decode(rs.body);

      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }
      print(body);
      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
    }
  }

  Future<void> getAllBooking(
      {required String token,
      List<String>? services,
      List<String>? status,
      List<String>? date,
      int? page,
      int? limit}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "service": services,
        "status": status,
        "date": date,
        "page": page.toString(),
        "limit": limit.toString()
      };

      queryParameters.removeWhere((key, value) => value == null);

      final uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}booking/bookings/find/all")
              ?.replace(queryParameters: queryParameters);
      print(uri);
      final rs = await http.get(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!);

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
      bookingList = List<Map<String, dynamic>>.from(
          httpResponseFlutter.result?['bookings']);
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
    }
  }
}
