class ServiceModel{
  List<String>? images; 
  String? name;
  String? description;
  int? price;
  String? id;
  Map<String,dynamic>? timeService;
  int? rating;
  int? views;
  ServiceModel({
    this.description,
    this.id,
    this.images,
    this.name,
    this.price,
    this.timeService,
    this.rating,
    this.views
  });

  factory ServiceModel.fromJson(Map<String,dynamic> json){
    return ServiceModel(
      images: List<String>.from(json["images"]),
      id: json['id'],
      name: json['name'],
      price: json['price'],
      timeService: Map<String,dynamic>.from(json['timeService']),
      description: json["description"],
      rating: json['rating'],
      views: json['views']
    );
  }
}