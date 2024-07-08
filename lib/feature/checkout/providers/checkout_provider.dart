import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:http/http.dart' as http;
import 'package:mobilefinalhcmus/feature/checkout/model/payment_method_model.dart';

class CheckoutProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  PaymentMethod chosenMethod = PaymentMethod();
  int _selectedPayMethod = 0;
  String? listenerFlag;
  void setSelectedPayMethod(int index) {
    _selectedPayMethod = index;
    notifyListeners();
  }

  int get selectedPayMethod => _selectedPayMethod;

  void update() {
    notifyListeners();
  }

  Future<HttpResponseFlutter> getPaymentMethods({required String token}) async {
    try {
      Uri uri = Uri.parse("${dotenv.env['HTTP_URI']}payment/method/find/all");
      final rs = await http.get(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri);
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

  Future<void> createOrder(
      {required String token,
      required String paymentMethod,
      required List<String> productsId,
      required List<int> quantities,
      required String phone,
      required String address,
      String? voucherId}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(isLoading: true);
      notifyListeners();
      Map<String, dynamic> data = {};
      data["productsId"] = productsId;
      data["quantities"] = quantities;
      data["phone"] = phone;
      data["address"] = address;
      data["paymentMethod"] = paymentMethod;
      data["voucherId"] = voucherId;
      data["paymentCallbackUrl"] =
          "http://nvukhoi.id.vn/api/payment/url/return?domain=nvukhoi.id.vn";

      data.removeWhere((key, value) => data[key] == null);
      Uri? uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/order/create");
      final rs = await http.post(uri!,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data));

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(result: result, statusCode: rs.statusCode);
      httpResponseFlutter.update(isLoading: false);
      notifyListeners();
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(isLoading: false);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
      notifyListeners();
    }
  }

  Future<void> cancelOrder(
      {
      required String token,
      required String orderId,
      String? note
      }) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(isLoading: true);
      notifyListeners();
      Map<String, dynamic> data = {};
      data['noteCancel'] = note;
      data['id'] = orderId;
      data.removeWhere((key, value) => data[key] == null);
      Uri? uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/order/cancel");
      final rs = await http.put(uri!,
          headers: {
            HttpHeaders.authorizationHeader: "Bearer $token",
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: json.encode(data));

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(result: result, statusCode: rs.statusCode);
      httpResponseFlutter.update(isLoading: false);

    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(isLoading: false);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }
}
