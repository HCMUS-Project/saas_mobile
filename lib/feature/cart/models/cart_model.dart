import 'package:mobilefinalhcmus/feature/shop/models/product_model.dart';

class CartModel{
  ProductModel product;
  int quantity;
  bool isSelected = false;
  CartModel({
    required this.product,
    required this.quantity
  });

  factory CartModel.fromJson(Map<String, dynamic>json){
    return CartModel(
      product: json['product'], 
      quantity: json['quantity']);
  }
}