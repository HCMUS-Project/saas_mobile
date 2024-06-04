import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/profie/models/order_model.dart';
import 'package:mobilefinalhcmus/feature/profie/views/constants/state_of_orders.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProfileProvider extends ChangeNotifier {
  String? _state = OrderState.values[0].name;
  String? get state => _state;
  List<OrderModel> _orderList = [];
  List<OrderModel> get orderList => _orderList;
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  Future<void> GetOrder({state}) async {
    _state = state;
    notifyListeners();
  }

  Future<void> getAllOrder({required String token, String? stage}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();

      Map<String, dynamic> queryParameters = {"stage": stage};
      queryParameters.removeWhere((key, value) => value == null);
      Uri? uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/order/search")?.replace(
            queryParameters: queryParameters
          );
      
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
      httpResponseFlutter.update(result: result, statusCode: rs.statusCode);
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }
  // Future<void> AddOrder(
  //     {required DateTime date,
  //     required String id,
  //     required List<ProductModel> products,
  //     required int quantity,
  //     required String stateOrder,
  //     required double total,
  //     required String trackingNumber}) async {
  //   httpResponseFlutter = HttpResponseFlutter.unknown();
  //   httpResponseFlutter.update(isLoading: true);
  //   notifyListeners();
  //   await Future.delayed(Duration(seconds: 1));
  //   _orderList.add(OrderModel(
  //       date: date,
  //       id: id,
  //       products: products,
  //       quantity: quantity,
  //       stateOrder: stateOrder,
  //       total: total,
  //       trackingNumber: trackingNumber));
  //   httpResponseFlutter.update(isLoading: false);
  //   notifyListeners();
  //   // await Future.delayed(Duration(seconds: 2));
  // }
}
