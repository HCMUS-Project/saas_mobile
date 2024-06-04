import 'package:flutter/cupertino.dart';

class HomeProvider extends ChangeNotifier{
  int? _seletedIndex = 0;
  int? temp = 0;
  int? get seletedIndex => _seletedIndex; 
  set setIndex(int index){
    _seletedIndex = index;
    notifyListeners();
  }

  set setTemp(int temp){
    this.temp = temp;
    notifyListeners();
  }
}