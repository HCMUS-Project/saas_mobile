import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/cart/models/cart_model.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import "package:http/http.dart" as http;

class CartProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  List<CartModel> _cartList = [];
  List<CartModel> get cartList => _cartList;
  List<CartModel> _selectedList = [];
  List<CartModel> get selectedList => _selectedList;
  String? _cartId;
  String? get cartId => _cartId;

  set setCartList(List<CartModel> list) {
    _cartList = list;
  }

  set setSelectedList(List<CartModel> list) {
    _selectedList = list;
  }

  int total = 0;
  set setTotal(int price){
    total = price;
    notifyListeners();
  }

  Future<void> getAllItem({required String token}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Uri? uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/cart/find/all");
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
      print(e.toJson()['message']);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }

  Future<void> updateCart(
      {required String token,
      required String cartId,
      required int quantity,
      required String productId}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      print(cartId);
      print(quantity);
      print(productId);
      Uri? uri = Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/cart/update");
      Map<String, dynamic> data = Map();
      data['id'] = cartId;
      data['cartItems'] = {"quantity": quantity, "productId": productId};

      final rs = await http.post(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!, body: json.encode(data));

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

  Future<void> addToCart(
      {required ProductModel product,
      required int quantity,
      required String token}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> data = Map();

      print("riuuiruiruite:${product.id}");
      print(quantity);

      data['userId'] = "any thing";
      data['cartItem'] = {"productId": product.id, "quantity": quantity};

      Uri? uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/cart/item/add");

      final rs = await http.post(headers: {
        HttpHeaders.authorizationHeader: "Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!, body: json.encode(data));

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

  void updateCheckout({required String typeFlag, required CartModel item}) {
    print("what the ${item.quantity}");

    if (typeFlag == "ADD_ITEM") {
      setTotal = (total ?? 0) + (item.product.price! * item.quantity);
      cartList.add(item);
    }

    if (typeFlag == "REMOVE_ITEM") {
      cartList.removeWhere((element) => element.product.id == item.product.id,);
      setTotal = ( total ?? 0) - (item.product.price! * item.quantity);
    }
    notifyListeners();
  }
}
