class VoucherModel {
  String? id;
  String? type;
  String? domain;
  String? voucherName;
  String? voucherCode;
  int? maxDiscount;
  int? minAppValue;
  double? discountPercent;
  String? expireAt;
  String? createdAt;
  String? updatedAt;
  bool? isChoose = false;
  VoucherModel ({
    this.createdAt,
    this.discountPercent,
    this.domain,
    this.expireAt,
    this.id,
    this.maxDiscount,
    this.minAppValue,
    this.type,
    this.updatedAt,
    this.voucherCode,
    this.voucherName,
  });

  
  factory VoucherModel.fromJson(Map<String,dynamic> json){
    return VoucherModel(
      id: json['id'],
      createdAt: json['createdAt'],
      discountPercent: json['discountPercent'],
      domain: json['domain'],
      expireAt: json['expireAt'],
      maxDiscount: json['maxDiscount'],
      minAppValue: json['minAppValue'],
      type: json['type'],
      updatedAt: json['updatedAt'],
      voucherCode: json['voucherCode'],
      voucherName: json['voucherName']
    );
  }
}