class ServiceModel {
  List<String>? images;
  String? name;
  String? description;
  int? price;
  String? id;
  int?numberRating;
  Map<String, dynamic>? timeService;
  double? rating;
  int? views;
  ServiceModel(
      {this.description,
      this.id,
      this.images,
      this.numberRating,
      this.name,
      this.price,
      this.timeService,
      this.rating,
      this.views});
  ServiceModel.unknown() : description =null, id =null, images=null, name= null, price=null, rating = null, timeService=null, views= null;
  void update(ServiceModel service) {
    this.description = service.description;
    this.id = service.id;
    this.images = service.images;
    this.name = service.name;
    this.price = service.price;
    this.rating = service.rating;
    this.timeService = service.timeService;
    this.views = service.views;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
        images: List<String>.from(json["images"]),
        id: json['id'],
        name: json['name'],
        price: json['price'],
        timeService: Map<String, dynamic>.from(json['timeService']),
        description: json["description"],
        rating: double.parse(json['rating'].toString()),
        views: json['views'],
        numberRating: json['numberRating']
        );
  }
}
