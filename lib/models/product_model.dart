class ProductModel {
  final dynamic id;
  String title;
  dynamic price;
  String description;
  String image;
  final RatingModel? rating;
  final String category;

  ProductModel({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(jsonData) {
    return ProductModel(
      id: jsonData['id'],
      title: jsonData['title'],
      category: jsonData['category'],
      price: jsonData['price'],
      description: jsonData['description'],
      image: jsonData['image'],
      rating: jsonData['rating'] == null
          ? null
          : RatingModel.fromJson(jsonData['rating']),
    );
  }

  // إضافة دوال لتحديث القيم
  void updateTitle(String newTitle) {
    title = newTitle;
  }

  void updateDescription(String newDescription) {
    description = newDescription;
  }

  void updatePrice(dynamic newPrice) {
    price = newPrice;
  }

  void updateImage(String newImage) {
    image = newImage;
  }
}

class RatingModel {
  final dynamic rate;
  final int count;

  RatingModel({required this.rate, required this.count});

  factory RatingModel.fromJson(jsonData) {
    return RatingModel(rate: jsonData['rate'], count: jsonData['count']);
  }
}



