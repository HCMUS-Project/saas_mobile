class PaymentMethod {
  String? imageUrl;
  String? type;
  bool? status;
  String? domain;
  String? id;

  PaymentMethod({this.imageUrl, this.type, this.domain, this.id,this.status});
  
  factory PaymentMethod.fromJson(
    Map<String,dynamic> json
  ) {
    return PaymentMethod(
      domain: json['domain'],
      id: json['id'],
      imageUrl: json['imageUrl'] ?? "assets/images/logo_payment.png",
      status: json['status'],
      type: json['type'],
    );
  }
}
