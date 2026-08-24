class ProductModel {
  final String id;
  final String userId;
  final String name;
  final double price;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.price,
    required this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {'name': name, 'price': price};
  }
}
