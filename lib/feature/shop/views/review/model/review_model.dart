class ReviewModel {
  String? id;
  String? type;
  String? domain;
  String? productId;
  String? user;
  double? rating;
  String? review;
  String? createdAt;
  String? updatedAt;

  ReviewModel(
    {
      this.id,
      this.type,
      this.domain,
      this.productId,
      this.user,
      this.rating,
      this.review,
      this.createdAt,
      this.updatedAt
    }
  );

  factory ReviewModel.fromJson(Map<String, dynamic> json){
    return ReviewModel(
      id: json['id'],
      type: json['type'],
      domain: json['domain'],
      createdAt: json['createdAt'],
      productId: json['productId'],
      rating: double.parse(json['rating'].toString()),
      review: json['review'],
      updatedAt: json['updateAt'],
      user: json['user']
    );
  }
}