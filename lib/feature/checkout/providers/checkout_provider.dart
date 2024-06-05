import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:http/http.dart' as http;

class CheckoutProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();

  Future<void> createOrder(
      {required String token,
      required List<String> productsId,
      required List<int> quantities,
      required String phone,
      required String address,
      String? voucherId}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(isLoading: true);
      notifyListeners();
      Map<String, dynamic> data = Map();
      data["productsId"] = productsId;
      data["quantities"] = quantities;
      data["phone"] = phone;
      data["address"] = address;
      data["voucherId"] = voucherId ?? "040421e4-fb5b-48b3-8947-9c41c1574261";
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
}
