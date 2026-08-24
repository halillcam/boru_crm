class PurchaseModel {
  final String id;
  final String customerId;
  final String productId;
  final String productName; // JOIN ile products tablosundan gelecek
  final double amount;
  final bool isPaid;
  final DateTime purchasedAt;

  PurchaseModel({
    required this.id,
    required this.customerId,
    required this.productId,
    required this.productName,
    required this.amount,
    required this.isPaid,
    required this.purchasedAt,
  });

  factory PurchaseModel.fromJson(Map<String, dynamic> json) {
    return PurchaseModel(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      productId: json['product_id'] as String,
      productName: json['products']['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      isPaid: json['is_paid'] as bool,
      purchasedAt: DateTime.parse(json['purchased_at'] as String),
    );
  }
}
