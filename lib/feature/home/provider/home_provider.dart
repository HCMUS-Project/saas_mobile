import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobilefinalhcmus/config/exception_config.dart';
import 'package:mobilefinalhcmus/config/http_response.dart';
import 'package:http/http.dart' as http;

class HomeProvider extends ChangeNotifier {
  HttpResponseFlutter httpResponseFlutter = HttpResponseFlutter.unknown();
  List<Map<String, dynamic>> banners = [];
  int? _seletedIndex = 0;
  int? temp = 0;
  int? get seletedIndex => _seletedIndex;


  set setIndex(int index) {
    _seletedIndex = index;
    notifyListeners();
  }

  set setTemp(int temp) {
    this.temp = temp;
    notifyListeners();
  }

  Future<void> getBanner({required String domain}) async {
    try {
      httpResponseFlutter = HttpResponseFlutter.unknown();
      Map<String, dynamic> queryParameters = {"domain": domain};
      Uri uri = Uri.parse("${dotenv.env['HTTP_URI']}tenant/banner/find")
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
      banners = List<Map<String, dynamic>>.from(
          httpResponseFlutter.result?['banners']);
      print("get banner success");
      notifyListeners();
    } on FlutterException catch (e) {
      print(e);
      httpResponseFlutter.update(
          errorMessage: e.toJson()['message'],
          statusCode: e.toJson()['statusCode']);
    }
  }
}
