import 'package:intl/intl.dart';

class CurrencyConfig extends Object {

  int? price;
  String? locale = "vi_VN";
  CurrencyConfig(
    {
      this.locale,
      this.price
    }
  );
  factory CurrencyConfig.convertTo(
    {
      required int price,
      String? locale
    }
  ){
    return CurrencyConfig(
      price: price ,
      locale: locale
    );
  }
  @override
  String toString(){
 
    return NumberFormat.simpleCurrency(
        name: "VND",
        decimalDigits: 0)
    .format(price);
  }
}