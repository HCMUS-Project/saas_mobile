import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';
import "package:http/http.dart" as http;

class ShopProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  List<ProductModel>? productList = [];
  List<String> get categoryList => productList!
      .map((e) => (e.category?[0]['name']).toString())
      .toList()
      .toSet()
      .toList();
  List<ProductModel>? _filterProductList = [];
  List<Map<String, dynamic>> reviews = [];
  List<ProductModel>? get filterProductList => _filterProductList;
  String? selectedCategory = "";
   
  
  set setProductList(List<ProductModel> productList) {
    print(productList);
    this.productList = productList;
    notifyListeners();
  }

  Future<HttpResponseFlutter> findProduct(
      {required String productId, required String domain}) async {
    print("searchProduct");
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "domain": domain,
        "id": productId
      };
      queryParameters.removeWhere((key, value) => value == null);
      Uri? uri = Uri.tryParse("${dotenv.env["HTTP_URI"]}ecommerce/product/find")
          ?.replace(queryParameters: queryParameters);
      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!);

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);

      HttpResponseFlutter responseHttpTemp = HttpResponseFlutter.unknown();
      responseHttpTemp.update(result: result, statusCode: body['statusCode']);

      return responseHttpTemp;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<HttpResponseFlutter> searchProduct(
      {required String domain,
      String? name,
      String? category,
      int? minPrice,
      int? maxPrice,
      int? rating}) async {
    try {
      
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(
        isLoading: true
      );

      Map<String, dynamic> queryParameters = {
        "domain": domain,
        "name": name,
        "category": category,
        "minPrice": minPrice.toString(),
        "maxPrice": maxPrice.toString(),
        "rating": rating.toString()
      }; 
      queryParameters.removeWhere((key, value) => value == null || value == "null");
      final uri =
          Uri.tryParse("${dotenv.env['HTTP_URI']}ecommerce/product/search/")
              ?.replace(queryParameters: queryParameters);
      print(uri);
      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri!);
      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);

      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode, isLoading: false);
      return httpResponseFlutter; 
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<void> getAllProduct({required String domain}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {"domain": domain};
      queryParameters.removeWhere((key, value) => value == null);

      final uri = Uri.parse("${dotenv.env['HTTP_URI']}ecommerce/product/find")
          .replace(queryParameters: queryParameters);
      final rs = await http.get(headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri);
      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      // final products =
      //     List<Map<String, dynamic>>.from(body['data']['products']);
      // _filterProductList =
      //     products.map<ProductModel>((e) => ProductModel.fromJson(e)).toList();
      // productList = _filterProductList;
      final result = Map<String, dynamic>.from(body['data']);
      httpResponseFlutter.update(result: result, statusCode: rs.statusCode);
    } on FlutterException catch (e) {
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
    }
  }

  void filterByCategory({
    int? categoryId,
  }) {
    int indexCategory = categoryId!;
    print(indexCategory);
    if (indexCategory > 0) {
      selectedCategory = categoryList[indexCategory - 1];
      notifyListeners();
      return;
    }
    selectedCategory = "";
    notifyListeners();
  }

  Future<HttpResponseFlutter> reviewOfProduct(
      {String? domain, String? productId, int? pageSize, int? page}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "domain": domain,
        "productId": productId,
        "pageSize": pageSize.toString(),
        "page": page.toString()
      };

      queryParameters.removeWhere((key, value) => value == null);
      final uri = Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/review/find')
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

      reviews = List<Map<String, dynamic>>.from(result['data']['reviews']);
      print(reviews);
      httpResponseFlutter.update(result: result['data'], statusCode: rs.statusCode);
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<HttpResponseFlutter> removeReviewProduct(
    {
      required String token,
      required String id
    }
  )async{
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      final uri = Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/review/delete/$id');
      final rs = await http.delete(headers: {
        HttpHeaders.authorizationHeader:"Bearer $token",
        'Content-type': 'application/json',
        'Accept': 'application/json',
      }, uri);
      final body = json.decode(rs.body);
      if (rs.statusCode >= 400) {
        throw FlutterException(body['message'], rs.statusCode);
      }

      final result = Map<String, dynamic>.from(body);
      httpResponseFlutter.update(result: result['data'], statusCode: rs.statusCode);
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }
  Future<HttpResponseFlutter> findProductTopSeller(
      {required String domain}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      httpResponseFlutter.update(isLoading: true);
      
      Map<String, dynamic> queryParameters = {
        "domain": domain,
      };

      queryParameters.removeWhere((key, value) => value == null);
      final uri =
          Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/product/find/best')
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

      httpResponseFlutter.update(
        isLoading: false,
          result: result['data'], statusCode: rs.statusCode);
      notifyListeners();
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<HttpResponseFlutter> findProductRecommend(
      {required String domain}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "domain": domain,
      };

      queryParameters.removeWhere((key, value) => value == null);
      final uri =
          Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/product/find/recommend')
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

      httpResponseFlutter.update(
          result: result['data'], statusCode: rs.statusCode);
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  Future<HttpResponseFlutter> getAllVoucher (
    {
      required String domain,
      String? code,
      String? id
    }
  )async{
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {
        "domain": domain,
        "code":code,
        "id":id
      };

      queryParameters.removeWhere((key, value) => value == null);
      final uri =
          Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/voucher/find')
              .replace(queryParameters: queryParameters);
      final rs = await http.get(
        headers: {
           'Content-type': 'application/json',
        'Accept': 'application/json',
        },
        uri
      );

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400){
        throw FlutterException(
          body['message'], rs.statusCode
        );
      }

      final resutl = Map<String,dynamic>.from(body);
      httpResponseFlutter.update(
        result: resutl['data'],
        statusCode: resutl['statusCode']
      );
      return httpResponseFlutter;
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
      return httpResponseFlutter;
    }
  }

  
  Future<void> ReviewProduct ({
    required String token,
    required String productId,
    String? userId,
    double? rating,
    required String review
  })async{
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      print(productId);
      print(userId);
      print("13123 $review");
      print(rating);
      Map<String, dynamic> data = {};
      data['productId'] = productId;
      // data['userId'] = userId ?? "volehoai070902@gmail.com";
      data['rating'] = rating;
      data['review'] = review;

      final uri = Uri.parse('${dotenv.env['HTTP_URI']}ecommerce/review/create');
      final rs = await http.post(
        headers: {
           'Content-type': 'application/json',
        'Accept': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer $token"
        },
        body: json.encode(data),
        uri,
        
      );

      final body = json.decode(rs.body);
      if (rs.statusCode >= 400){
        throw FlutterException(
          body['message'], rs.statusCode
        );
      }
      
      final resutl = Map<String,dynamic>.from(body);
      httpResponseFlutter.update(
        result: resutl['data'],
        statusCode: resutl['statusCode']
      );
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          result: e.toJson()['message'], statusCode: e.toJson()['statusCode']);
    }
  }

  
}
