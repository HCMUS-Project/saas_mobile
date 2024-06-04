class ProductModel {
  String? name;
  List<Map<String,dynamic>>? category;
  List<String>? image;
  int? price;
  int? quantity;
  String? description;
  String? id;
  double? rating;
  int? numberRating;

  ProductModel({
    this.id,
    this.category,
    this.name,
    this.image,
    this.price,
    this.quantity,
    this.description,
    this.numberRating,
    this.rating
  });


  factory ProductModel.fromJson(Map<String,dynamic>? product){
    String? rating = product?['rating'].toString();
    String? numberRating = product?['numberRating'].toString();

    return ProductModel(
      id: product?['id'],
      category:List<Map<String,dynamic>>.from( product?['categories']),
      image:List<String>.from(product?['images']),
      name: product?['name'],
      price: product?['price'],
      description: product?['description'],
      quantity: product?['quantity'],
      numberRating: int.parse( numberRating!),
      rating:double.parse( rating!),
    );
  }
}