import 'package:intl/intl.dart';

class OrderModel{
  String? id;
  String? trackingNumber;
  int? quantity;
  DateTime? date;
  int? total;
  String? stateOrder;
  List<Map<String,dynamic>>? products;
  String? voucherId;
  String? address;
  String? phone;
  OrderModel({
    this.products,
    this.date,
    this.quantity,
    this.id,
    this.stateOrder,
    this.total,
    this.trackingNumber,
    this.voucherId,
    this.phone,
    this.address
  });

  factory OrderModel.toJson(Map<String, dynamic>json) {
    final datetime = DateFormat("EE MMM dd y H:m:s 'GMT'").parseUTC(json['orderTime']);
    return OrderModel(
      date: datetime.toLocal() ?? DateTime.now(),
      quantity: List<Map<String,dynamic>>.from(json['products']).length,
      stateOrder: json['stage'],
      total: json['totalPrice'] ?? 0,
      trackingNumber: json['orderId'],
      products: List<Map<String,dynamic>>.from(json['products']),
      voucherId: json['voucherId'],
      address: json['address'],
      phone: json['phone'],
    );
  }
}